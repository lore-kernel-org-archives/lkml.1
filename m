Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbXFWSg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbXFWSg0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXFWSgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:36:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbXFWSgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:36:15 -0400
Date: Sat, 23 Jun 2007 11:35:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: spock@gentoo.org
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fbdev: uvesafb driver
Message-Id: <20070623113557.f0295218.akpm@linux-foundation.org>
In-Reply-To: <20070623105243.GD12623@spock.one.pl>
References: <20070623105243.GD12623@spock.one.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 12:52:43 +0200 Michal Januszewski <spock@gentoo.org> wrote:

> Add the uvesafb driver, an enhanced version of vesafb that makes use of
> a userspace helper to run x86 Video BIOS code.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> ---
>  drivers/video/Kconfig   |   18 +
>  drivers/video/Makefile  |    1 +
>  drivers/video/uvesafb.c | 1902 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/video/Kbuild    |    2 +-
>  include/video/uvesafb.h |  208 ++++++
>  5 files changed, 2130 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 403dac7..5cc03f9 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -585,6 +585,24 @@ config FB_TGA
>  
>  	  Say Y if you have one of those.
>  
> +config FB_UVESA
> +	tristate "Userspace VESA VGA graphics support"
> +	depends on FB && CONNECTOR

These dependencies are insufficient.

> ...
>
> --- /dev/null
> +++ b/drivers/video/uvesafb.c
> @@ -0,0 +1,1902 @@
> +/*
> + * A framebuffer driver for VBE 2.0+ compliant video cards
> + *
> + * (c) 2007 Michal Januszewski <spock@gentoo.org>
> + *     Loosely based upon the vesafb driver.
> + *
> + */
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/skbuff.h>
> +#include <linux/timer.h>
> +#include <linux/completion.h>
> +#include <linux/connector.h>
> +#include <linux/random.h>
> +#include <linux/platform_device.h>
> +#include <linux/limits.h>
> +#include <linux/fb.h>
> +#include <video/edid.h>
> +#include <video/vga.h>
> +#include <video/uvesafb.h>
> +#include <asm/io.h>
> +#include <asm/mtrr.h>

Only x86 has mtrr.h: you just broke allmodconfig on all other
architectures.

> +#include "edid.h"
> +
> +static struct cb_id uvesafb_cn_id = {
> +	.idx = CN_IDX_V86D,
> +	.val = CN_VAL_V86D_UVESAFB
> +};
> +static struct sock *nls;
> +static char v86d_path[PATH_MAX] = "/sbin/v86d";

Remove the PATH_MAX, save some memory.

Oh, it gets set via sysfs.  hrm.


> +static char v86d_started = 0;	/* has v86d been started by uvesafb? */

Unneeded initialisation-to-zero.

scripts/checkpatch.pl would have reported this.  It in fact generates 93
warnings against this patch and from a quick scan, they all look
legitimate.

> +static void uvesafb_cn_callback(void *data)
> +{
> +	struct cn_msg *msg = (struct cn_msg *)data;

unneeded cast of void*

> +	struct uvesafb_task *utask = (struct uvesafb_task *)msg->data;
> +	struct uvesafb_ktask *task;
> +
> +	if (msg->seq >= UVESAFB_TASKS_MAX)
> +		return;
> +
> +	task = uvfb_tasks[msg->seq];
> +
> +	if (!task || msg->ack != task->ack)
> +		return;
> +
> +	memcpy(&task->t, utask, sizeof(struct uvesafb_task));
> +
> +	if (task->t.buf_len && task->buf)
> +		memcpy(task->buf, ((u8*)utask) + sizeof(struct uvesafb_task),
> +						task->t.buf_len);

Isn't this

	memcpy(task->buf, utask + 1, task->t.buf_len);
?

> +
> +	complete(task->done);
> +	return;
> +}
> +
> +static int uvesafb_helper_start(void)
> +{
> +	char *envp[] = {
> +		"HOME=/",
> +		"PATH=/sbin:/bin",
> +		NULL,
> +	};
> +
> +	char *argv[] = {
> +		v86d_path,
> +		NULL,
> +	};
> +
> +	return call_usermodehelper(v86d_path, argv, envp, 1);
> +}

Now I'm wondering what this code actually does.  It would be nice to have
an overall design and implementation description in the changelog so we
don't have to reverse-engineer your thoughts from your implementation...

The comment over uvesafb_exec() helps.

> +static struct uvesafb_ktask *uvesafb_prep(void)
> +{
> +	struct uvesafb_ktask *task;
> +
> +	task = kzalloc(sizeof(struct uvesafb_ktask), GFP_ATOMIC);
> +	if (task) {
> +		task->done = kzalloc(sizeof(struct completion), GFP_ATOMIC);
> +		if (!task->done) {
> +			kfree(task);
> +			task = NULL;
> +		}
> +	}
> +	return task;
> +}

GFP_ATOMIC is unreliable and should be strenuously avoided.  I suspect all
callers can use GFP_KERNEL here.  If not, we should at least pass the gfp_t
into this function as an argument so that we can use GFP_KERNEL from as
many callsites as possible.

> +/*
> + * Execute a uvesafb task.
> + *
> + * Returns 0 if the task is executed successfully.
> + *
> + * A message sent to the userspace consists of the uvesafb_task
> + * struct and (optionally) a buffer. The uvesafb_task struct is
> + * a simplified version of uvesafb_ktask (its kernel counterpart)
> + * containing only the register values, flags and the length of
> + * the buffer.
> + *
> + * Each message is assigned a sequence number (increased linearly)
> + * and a random ack number. The sequence number is used as a key
> + * for the uvfb_tasks array which holds pointers to uvesafb_ktask
> + * structs for all requests.
> + */
> +static int uvesafb_exec(struct uvesafb_ktask *task)
> +{
> +	static int seq = 0;
> +	struct cn_msg *m;
> +	int err;
> +	int len = sizeof(task->t) + task->t.buf_len;
> +
> +	/* Check whether the message isn't longer than the maximum
> +	 * allowed by connector */
> +	if (sizeof(*m) + len > CONNECTOR_MAX_MSG_SIZE) {
> +		printk(KERN_WARNING "uvesafb: message too long (%d), "
> +				"can't exec task\n", (int)(sizeof(*m) + len));
> +		return -E2BIG;
> +	}
> +
> +	m = kmalloc(sizeof(*m) + len, GFP_ATOMIC);

More GFP_ATOMIC badness

> +	if (!m)
> +		return -ENOMEM;
> +
> +	init_completion(task->done);
> +
> +	memset(m, 0, sizeof(*m) + len);

kzalloc()

> +	memcpy(&m->id, &uvesafb_cn_id, sizeof(m->id));
> +	m->seq = seq;
> +	m->len = len;
> +	m->ack = random32();
> +
> +	/* uvesafb_task structure */
> +	memcpy(m + 1, &task->t, sizeof(task->t));
> +
> +	/* Buffer */
> +	memcpy((u8*)m + sizeof(task->t) + sizeof(*m),
> +		task->buf, task->t.buf_len);
> +
> +	/* Save the message ack number so that we can find the kernel
> +	 * part of this task when a reply is received from userspace. */
> +	task->ack = m->ack;
> +
> +	/* If all slots are taken -- bail out. */
> +	if (uvfb_tasks[seq])
> +		return -EBUSY;
> +
> +	/* Save a pointer to the kernel part of the task struct. */
> +	uvfb_tasks[seq] = task;
> +
> +	err = cn_netlink_send(m, 0, gfp_any());
> +	if (err == -ESRCH) {
> +		/* Try to start the userspace helper if sending
> +		 * the request failed the first time. */
> +		err = uvesafb_helper_start();
> +		if (err) {
> +			printk(KERN_ERR "uvesafb: failed to execute %s\n",
> +					v86d_path);
> +			printk(KERN_ERR "uvesafb: make sure that the v86d"
> +					"helper is installed and executable\n");
> +		} else {
> +			v86d_started = 1;
> +			err = cn_netlink_send(m, 0, gfp_any());
> +		}
> +	}
> +	kfree(m);
> +
> +	if (!err && !(task->t.flags & TF_EXIT))
> +		err = !wait_for_completion_timeout(task->done,
> +				msecs_to_jiffies(UVESAFB_TIMEOUT));

If you can run wait_for_completion() here then you can use GFP_KERNEL up
there.

> +	uvfb_tasks[seq] = NULL;
> +
> +	seq++;
> +	if (seq >= UVESAFB_TASKS_MAX)
> +		seq = 0;
> +
> +	return err;
> +}
>
> ...
>
> +static int __devinit uvesafb_vbe_getinfo(struct uvesafb_ktask *task,
> +	struct uvesafb_par *par)
> +{
> +	int err;
> +
> +	task->t.regs.eax = 0x4f00;
> +	task->t.flags = TF_VBEIB;
> +	task->t.buf_len = sizeof(struct vbe_ib);
> +	task->buf = (u8*) &par->vbe_ib;
> +	strncpy(par->vbe_ib.vbe_signature, "VBE2", 4);
> +
> +	err = uvesafb_exec(task);
> +	if (err || (task->t.regs.eax & 0xffff) != 0x004f) {
> +		printk(KERN_ERR "uvesafb: Getting VBE info block failed "
> +				"(eax=0x%x, err=%x)\n", (u32)task->t.regs.eax,
> +				err);
> +		return -EINVAL;
> +	}
> +
> +	if (par->vbe_ib.vbe_version < 0x0200) {
> +		printk(KERN_ERR "uvesafb: Sorry, pre-VBE 2.0 cards are "
> +				"not supported.\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!par->vbe_ib.mode_list_ptr) {
> +	    printk(KERN_ERR "uvesafb: Missing mode list!\n");
> +	    return -EINVAL;

whitespace went wonky here.

> +	}
> +
> +	printk(KERN_INFO "uvesafb: ");
> +
> +	/* Convert string pointers and the mode list pointer into
> +	 * usable addresses. Print informational messages about the
> +	 * video adapter and its vendor. */

Commenting style is

	/* Convert string pointers and the mode list pointer into
	 * usable addresses. Print informational messages about the
	 * video adapter and its vendor.
	 */

or

	/*
	 * Convert string pointers and the mode list pointer into
	 * usable addresses. Print informational messages about the
	 * video adapter and its vendor.
	 */

> +	if (par->vbe_ib.oem_vendor_name_ptr)
> +		printk("%s, ",
> +			(char*)(task->buf + par->vbe_ib.oem_vendor_name_ptr));
> +
> +	if (par->vbe_ib.oem_product_name_ptr)
> +		printk("%s, ",
> +			(char*)(task->buf + par->vbe_ib.oem_product_name_ptr));
> +
> +	if (par->vbe_ib.oem_product_rev_ptr)
> +		printk("%s, ",
> +			(char*)(task->buf + par->vbe_ib.oem_product_rev_ptr));
> +
> +	if (par->vbe_ib.oem_string_ptr)
> +		printk("OEM: %s, ",
> +			(char*)(task->buf + par->vbe_ib.oem_string_ptr));
> +
> +	printk("VBE v%d.%d\n", ((par->vbe_ib.vbe_version & 0xff00) >> 8),
> +			par->vbe_ib.vbe_version & 0xff);
> +
> +	return 0;
> +}
> +
> +static int __devinit uvesafb_vbe_getmodes(struct uvesafb_ktask *task,
> +		struct uvesafb_par *par)
> +{
> +	int off = 0, err;
> +	u16 *mode;
> +
> +	par->vbe_modes_cnt = 0;
> +
> +	/* Count available modes. */
> +	mode = (u16*) (((u8*)&par->vbe_ib) + par->vbe_ib.mode_list_ptr);
> +	while (*mode != 0xffff) {
> +		par->vbe_modes_cnt++;
> +		mode++;
> +	}
> +
> +	par->vbe_modes = kzalloc(sizeof(struct vbe_mode_ib) *
> +				par->vbe_modes_cnt, GFP_KERNEL);
> +	if (!par->vbe_modes)
> +		return -ENOMEM;
> +
> +	/* Get info about all available modes. */
> +	mode = (u16*) (((u8*)&par->vbe_ib) + par->vbe_ib.mode_list_ptr);
> +	while (*mode != 0xffff) {
> +		struct vbe_mode_ib *mib;
> +
> +		uvesafb_reset(task);
> +		task->t.regs.eax = 0x4f01;
> +		task->t.regs.ecx = (u32) *mode;
> +		task->t.flags = TF_BUF_RET | TF_BUF_ESDI;
> +		task->t.buf_len = sizeof(struct vbe_mode_ib);
> +		task->buf = (u8*) (par->vbe_modes + off);
> +
> +		err = uvesafb_exec(task);
> +		if (err || (task->t.regs.eax & 0xffff) != 0x004f) {
> +			printk(KERN_ERR "uvesafb: Getting mode info block "
> +				"for mode 0x%x failed (eax=0x%x, err=%x)\n",
> +				*mode, (u32)task->t.regs.eax, err);
> +			return -EINVAL;
> +		}
> +
> +		mib = (struct vbe_mode_ib*)task->buf;

Perhaps uvesafb_ktask.buf should be void* so we can lose some typecasts.

> +		mib->mode_id = *mode;
> +
> +		/* We only want modes that are supported with the current
> +		 * hardware configuration, color, graphics and that have
> +		 * support for the LFB. */
> +		if ((mib->mode_attr & VBE_MODE_MASK) == VBE_MODE_MASK &&
> +		     mib->bits_per_pixel >= 8) {
> +			off++;
> +		} else {
> +			par->vbe_modes_cnt--;
> +		}
> +		mode++;
> +		mib->depth = mib->red_len + mib->green_len + mib->blue_len;
> +
> +		/* Handle 8bpp modes and modes with broken color component
> +		 * lengths. */
> +		if (mib->depth == 0 || (mib->depth == 24 &&
> +					mib->bits_per_pixel == 32))
> +			mib->depth = mib->bits_per_pixel;
> +	}
> +
> +	return 0;
> +}
> +
> +#ifdef __i386__

CONFIG_X86 would be more typical.

Be aware that CONFIG_X86 is true for both i386 and x86_64.  You don't state
whether this code works on x86_64.  If it can, it should.

> +static int __devinit uvesafb_vbe_getpmi(struct uvesafb_ktask *task,
> +		struct uvesafb_par *par)
> +{
> +	int i, err;
> +
> +	uvesafb_reset(task);
> +	task->t.regs.eax = 0x4f0a;
> +	task->t.regs.ebx = 0x0;
> +	err = uvesafb_exec(task);
> +
> +	if ((task->t.regs.eax & 0xffff) != 0x4f || task->t.regs.es < 0xc000) {
> +		par->pmi_setpal = par->ypan = 0;
> +	} else {
> +		par->pmi_base = (u16*)phys_to_virt(((u32)task->t.regs.es << 4)
> +						+ task->t.regs.edi);
> +		par->pmi_start = (void*)((char*)par->pmi_base +
> +						par->pmi_base[1]);
> +		par->pmi_pal = (void*)((char*)par->pmi_base +
> +						par->pmi_base[2]);
> +		printk(KERN_INFO "uvesafb: protected mode interface info at "
> +				 "%04x:%04x\n",
> +				 (u16)task->t.regs.es, (u16)task->t.regs.edi);
> +		printk(KERN_INFO "uvesafb: pmi: set display start = %p, "
> +				 "set palette = %p\n", par->pmi_start,
> +				 par->pmi_pal);
> +
> +		if (par->pmi_base[3]) {
> +			printk(KERN_INFO "uvesafb: pmi: ports = ");
> +			for (i = par->pmi_base[3]/2;
> +					par->pmi_base[i] != 0xffff; i++)
> +				printk("%x ", par->pmi_base[i]);
> +			printk("\n");
> +
> +			if (par->pmi_base[i] != 0xffff) {
> +				printk(KERN_INFO "uvesafb: can't handle memory"
> +						 " requests, pmi disabled\n");
> +				par->ypan = par->pmi_setpal = 0;
> +			}
> +		}
> +	}
> +	return 0;
> +}
> +#endif

You might care to cc "H.  Peter Anvin" <hpa@zytor.com> on the next version
of this patch - he's a whizz at this sort of low-level x86 bios
communication stuff.

> +/* Check whether a video mode is supported by the Video BIOS and is
> + * compatible with the monitor limits. */
> +static int __devinit uvesafb_is_valid_mode(struct fb_videomode *mode,
> +		struct fb_info *info)
> +{
> +	if (info->monspecs.gtf) {
> +		fb_videomode_to_var(&info->var, mode);
> +		if (fb_validate_mode(&info->var, info))
> +			return -1;
> +	}
> +
> +	if (uvesafb_vbe_find_mode(info->par, mode->xres, mode->yres, 8,
> +				UVESAFB_NEED_EXACT_RES) == -1)
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static int __devinit uvesafb_vbe_getedid(struct uvesafb_ktask *task,
> +		struct fb_info *info)
> +{
> +	struct uvesafb_par *par = (struct uvesafb_par *)info->par;

fb_info.par has type void* hence all casts such as the above can and should
be removed.

> +	int err = 0;
> +
> +	if (noedid || par->vbe_ib.vbe_version < 0x0300)
> +		return -EINVAL;
> +
> +	task->t.regs.eax = 0x4f15;
> +	task->t.regs.ebx = 0;
> +	task->t.regs.ecx = 0;
> +	task->t.buf_len = 0;
> +	task->t.flags = 0;
> +
> +	err = uvesafb_exec(task);
> +
> +	if ((task->t.regs.eax & 0xffff) != 0x004f || err)
> +		return -EINVAL;
> +
> +	if ((task->t.regs.ebx & 0x3) == 3) {
> +		printk(KERN_INFO "uvesafb: VBIOS/hardware supports both "
> +				 "DDC1 and DDC2 transfers\n");
> +	} else if ((task->t.regs.ebx & 0x3) == 2) {
> +		printk(KERN_INFO "uvesafb: VBIOS/hardware supports DDC2 "
> +				 "transfers\n");
> +	} else if ((task->t.regs.ebx & 0x3) == 1) {
> +		printk(KERN_INFO "uvesafb: VBIOS/hardware supports DDC1 "
> +				 "transfers\n");
> +	} else {
> +		printk(KERN_INFO "uvesafb: VBIOS/hardware doesn't support "
> +				 "DDC transfers\n");
> +		return -EINVAL;
> +	}
> +
> +	task->t.regs.eax = 0x4f15;
> +	task->t.regs.ebx = 1;
> +	task->t.regs.ecx = task->t.regs.edx = 0;
> +	task->t.flags = TF_BUF_RET | TF_BUF_ESDI;
> +	task->t.buf_len = EDID_LENGTH;
> +	task->buf = kzalloc(EDID_LENGTH, GFP_KERNEL);
> +
> +	err = uvesafb_exec(task);
> +
> +	if ((task->t.regs.eax & 0xffff) == 0x004f && !err) {
> +		fb_edid_to_monspecs(task->buf, &info->monspecs);
> +
> +		if (info->monspecs.vfmax && info->monspecs.hfmax) {
> +			/* If the maximum pixel clock wasn't specified in
> +			 * the EDID block, set it to 300 MHz. */
> +			if (info->monspecs.dclkmax == 0)
> +				info->monspecs.dclkmax = 300 * 1000000;
> +			info->monspecs.gtf = 1;
> +		}
> +	} else {
> +		err = -EINVAL;
> +	}
> +
> +	kfree(task->buf);
> +	return err;
> +}
> +
> +static void __devinit uvesafb_vbe_getmonspecs(struct uvesafb_ktask *task,
> +		struct fb_info *info)
> +{
> +	struct uvesafb_par *par = info->par;
> +	int i;
> +	memset(&info->monspecs, 0, sizeof(struct fb_monspecs));

Missing a newline above.

> +	/* If we don't get all necessary data from the EDID block,
> +	 * mark it as incompatible with the GTF. */
> +	if (uvesafb_vbe_getedid(task, info))
> +		info->monspecs.gtf = 0;
> +
> +	/* Kernel command line overrides. */
> +	if (maxclk)
> +		info->monspecs.dclkmax = maxclk * 1000000;
> +	if (maxvf)
> +		info->monspecs.vfmax = maxvf;
> +	if (maxhf)
> +		info->monspecs.hfmax = maxhf * 1000;
> +
> +	/* In case DDC transfers are not supported the user can provide
> +	 * monitor limits manually. Lower limits are set to "safe" values. */
> +	if (info->monspecs.gtf == 0 && maxclk && maxvf && maxhf) {
> +		info->monspecs.dclkmin = 0;
> +		info->monspecs.vfmin = 60;
> +		info->monspecs.hfmin = 29000;
> +		info->monspecs.gtf = 1;
> +	}
> +
> +	if (info->monspecs.gtf)
> +		printk(KERN_INFO
> +			"uvesafb: monitor limits: vf = %d Hz, hf = %d kHz, "
> +			"clk = %d MHz\n", info->monspecs.vfmax,
> +			(int)(info->monspecs.hfmax / 1000),
> +			(int)(info->monspecs.dclkmax / 1000000));
> +	else
> +		printk(KERN_INFO "uvesafb: no monitor limits have been set\n");
> +
> +	/* Add VBE modes to the modelist. */
> +	for (i = 0; i < par->vbe_modes_cnt; i++) {
> +		struct fb_var_screeninfo var;
> +		struct vbe_mode_ib *mode;
> +		struct fb_videomode vmode;
> +
> +		mode = &par->vbe_modes[i];
> +		memset(&var, 0, sizeof(var));
> +
> +		var.xres = mode->x_res;
> +		var.yres = mode->y_res;
> +
> +		fb_get_mode(FB_VSYNCTIMINGS | FB_IGNOREMON, 60, &var, info);
> +		fb_var_to_videomode(&vmode, &var);
> +		fb_add_videomode(&vmode, &info->modelist);
> +	}
> +
> +	/* Add valid VESA modes to our modelist. */
> +	for (i = 0; i < VESA_MODEDB_SIZE; i++) {
> +		if (!uvesafb_is_valid_mode((struct fb_videomode*)
> +						&vesa_modes[i], info))
> +			fb_add_videomode(&vesa_modes[i], &info->modelist);
> +	}
> +
> +	for (i = 0; i < info->monspecs.modedb_len; i++) {
> +		if (!uvesafb_is_valid_mode(&info->monspecs.modedb[i], info))
> +			fb_add_videomode(&info->monspecs.modedb[i],
> +					&info->modelist);
> +	}
> +
> +	return;
> +}
> +
> +static void __devinit uvesafb_vbe_getstatesize(struct uvesafb_ktask *task,
> +		struct uvesafb_par *par)
> +{
> +	int err;
> +	uvesafb_reset(task);

Here also.

> +	/* Get the VBE state buffer size. We want all available
> +	 * hardware state data (CL = 0x0f). */
> +	task->t.regs.eax = 0x4f04;
> +	task->t.regs.ecx = 0x000f;
> +	task->t.regs.edx = 0x0000;
> +	task->t.flags = 0;
> +
> +	err = uvesafb_exec(task);
> +
> +	if (err || (task->t.regs.eax & 0xffff) != 0x004f) {
> +		printk(KERN_WARNING "uvesafb: VBE state buffer size "
> +			"cannot be determined (eax=0x%x, err=%d)\n",
> +			task->t.regs.eax, err);
> +		par->vbe_state_size = 0;
> +		return;
> +	}
> +
> +	par->vbe_state_size = 64 * (task->t.regs.ebx & 0xffff);
> +}
> +
> +static int __devinit uvesafb_vbe_init(struct fb_info *info)
> +{
> +	struct uvesafb_ktask *task = NULL;
> +	struct uvesafb_par *par = info->par;
> +	int err;
> +
> +	task = uvesafb_prep();
> +	if (!task)
> +		return -ENOMEM;
> +
> +	if ((err = uvesafb_vbe_getinfo(task, par)))

checkpatch.pl will do my work here..

> +		goto out;
> +	if ((err = uvesafb_vbe_getmodes(task, par)))
> +		goto out;
> +	par->nocrtc = nocrtc;
> +#ifdef __i386__
> +	par->pmi_setpal = pmi_setpal;
> +	par->ypan = ypan;
> +
> +	if (par->pmi_setpal || par->ypan)
> +		uvesafb_vbe_getpmi(task, par);
> +#else
> +	/* The protected mode interface is not available on non-x86. */
> +	par->pmi_setpal = par->ypan = 0;
> +#endif
> +
> +	INIT_LIST_HEAD(&info->modelist);
> +	uvesafb_vbe_getmonspecs(task, info);
> +	uvesafb_vbe_getstatesize(task, par);
> +
> +out:	uvesafb_free(task);
> +	return err;
> +}
> +
> +static int __devinit uvesafb_vbe_init_mode(struct fb_info *info)
> +{
> +	struct list_head *pos;
> +	struct fb_modelist *modelist;
> +	struct fb_videomode *mode;
> +	struct uvesafb_par *par = info->par;
> +	int i, modeid;
> +
> +	/* Has the user requested a specific VESA mode? */
> +	if (vbemode) {
> +		for (i = 0; i < par->vbe_modes_cnt; i++) {
> +			if (par->vbe_modes[i].mode_id == vbemode) {
> +				fb_get_mode(FB_VSYNCTIMINGS | FB_IGNOREMON, 60,
> +							&info->var, info);
> +				/* With pixclock set to 0, the default BIOS
> +				 * timings will be used in set_par(). */
> +				info->var.pixclock = 0;
> +				modeid = i;
> +				goto gotmode;
> +			}
> +		}
> +		printk(KERN_INFO "uvesafb: requested VBE mode 0x%x is "
> +				 "unavailable\n", vbemode);
> +		vbemode = 0;
> +	}
> +
> +	i = 0;
> +	list_for_each(pos, &info->modelist) {
> +		i++;
> +	}

Unneeded braces

> +	mode = kzalloc(i * sizeof(*mode), GFP_KERNEL);

Check for and handle the allocation failure, please.

> +	i = 0;
> +	list_for_each(pos, &info->modelist) {
> +		modelist = list_entry(pos, struct fb_modelist, list);
> +		mode[i] = modelist->mode;
> +		i++;
> +	}
> +
> +	if (!mode_option)
> +		mode_option = UVESAFB_DEFAULT_MODE;
> +
> +	i = fb_find_mode(&info->var, info, mode_option, mode, i,
> +		NULL, 8);
> +
> +	kfree(mode);
> +
> +	/* fb_find_mode() failed */
> +	if (i == 0 || i >= 3) {
> +		info->var.xres = 640;
> +		info->var.yres = 480;
> +		mode = (struct fb_videomode*)
> +				fb_find_best_mode(&info->var, &info->modelist);
> +
> +		if (mode) {
> +			fb_videomode_to_var(&info->var, mode);
> +		} else {
> +			modeid = par->vbe_modes[0].mode_id;
> +			fb_get_mode(FB_VSYNCTIMINGS | FB_IGNOREMON, 60,
> +				    &info->var, info);
> +			goto gotmode;
> +		}
> +	}
> +
> +	/* Look for a matching VBE mode. */
> +	modeid = uvesafb_vbe_find_mode(par, info->var.xres, info->var.yres,
> +			info->var.bits_per_pixel, UVESAFB_NEED_EXACT_RES);
> +
> +	if (modeid == -1)
> +		return -EINVAL;
> +
> +gotmode:
> +	uvesafb_setup_var(&info->var, info, &par->vbe_modes[modeid]);
> +
> +	/* If we are not VBE3.0+ compliant, we're done -- the BIOS will
> +	 * ignore our mode timings anyway. */
> +	if (par->vbe_ib.vbe_version < 0x0300)
> +		fb_get_mode(FB_VSYNCTIMINGS | FB_IGNOREMON, 60,
> +					&info->var, info);
> +
> +	return modeid;
> +}
> +
> +static int uvesafb_setpalette(struct uvesafb_pal_entry *entries, int count,
> +			     int start, struct fb_info *info)
> +{
> +	struct uvesafb_ktask *task;
> +	struct uvesafb_par *par = info->par;
> +	int i = par->mode_idx;
> +	int err = 0;
> +
> +	/* We support palette modifications for 8 bpp modes only, so
> +	 * there can never be more than 256 entries. */
> +	if (start + count > 256)
> +		return -EINVAL;
> +
> +	/* Use VGA registers if mode is VGA-compatible. */
> +	if (i >= 0 && i < par->vbe_modes_cnt &&
> +	    par->vbe_modes[i].mode_attr & VBE_MODE_VGACOMPAT) {
> +		for (i = 0; i < count; i++) {
> +			outb_p(start + i,        dac_reg);
> +			outb_p(entries[i].red,   dac_val);
> +			outb_p(entries[i].green, dac_val);
> +			outb_p(entries[i].blue,  dac_val);
> +		}
> +	} else if (par->pmi_setpal) {
> +		__asm__ __volatile__(
> +		"call *(%%esi)"
> +		: /* no return value */
> +		: "a" (0x4f09),         /* EAX */
> +		  "b" (0),              /* EBX */
> +		  "c" (count),          /* ECX */
> +		  "d" (start),          /* EDX */
> +		  "D" (entries),        /* EDI */
> +		  "S" (&par->pmi_pal)); /* ESI */

uh, so we're CONFIG_X86_32-only, yes?

> +	} else {
> +		task = uvesafb_prep();
> +		if (!task)
> +			return -ENOMEM;
> +
> +		task->t.regs.eax = 0x4f09;
> +		task->t.regs.ebx = 0x0;
> +		task->t.regs.ecx = count;
> +		task->t.regs.edx = start;
> +		task->t.flags = TF_BUF_ESDI;
> +		task->t.buf_len = sizeof(struct uvesafb_pal_entry) * count;
> +		task->buf = (u8*) entries;
> +
> +		err = uvesafb_exec(task);
> +		if ((task->t.regs.eax & 0xffff) != 0x004f)
> +			err = 1;
> +
> +		uvesafb_free(task);
> +	}
> +	return err;
> +}
> +
>
> ...
>
> +
> +static struct device_attribute device_attrs[] = {
> +	__ATTR(vbe_version, S_IRUGO, uvesafb_show_vbe_ver, NULL),
> +	__ATTR(vbe_modes, S_IRUGO, uvesafb_show_vbe_modes, NULL),
> +	__ATTR(oem_vendor, S_IRUGO, uvesafb_show_vendor, NULL),
> +	__ATTR(oem_product_name, S_IRUGO, uvesafb_show_product_name, NULL),
> +	__ATTR(oem_product_rev, S_IRUGO, uvesafb_show_product_rev, NULL),
> +	__ATTR(oem_string, S_IRUGO, uvesafb_show_oem_string, NULL),
> +	__ATTR(nocrtc, S_IRUGO | S_IWUSR, uvesafb_show_nocrtc,
> +		uvesafb_store_nocrtc),
> +};

Can we use an attribute group here?

> +static void __devinit uvesafb_create_sysfs(struct device *dev,
> +		struct fb_info *info)
> +{
> +	int i, err = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(device_attrs); i++) {
> +		err |= device_create_file(dev, &device_attrs[i]);
> +	}

Unneeded braces

> +	if (err != 0)
> +		printk(KERN_WARNING "fb%d: failed to register attributes\n",
> +			info->node);
> +}
> +
> +static void __devinit uvesafb_remove_sysfs(struct device *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(device_attrs); i++) {
> +		device_remove_file(dev, &device_attrs[i]);
> +	}

ditto

> +}
> +
> +static int __devinit uvesafb_probe(struct platform_device *dev)
> +{
> +	struct fb_info *info;
> +	struct vbe_mode_ib *mode = NULL;
> +	struct uvesafb_par *par;
> +	int err = 0, i;
> +
> +	info = framebuffer_alloc(sizeof(*par) +	sizeof(u32) * 256, &dev->dev);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	par = info->par;
> +
> +	if ((err = uvesafb_vbe_init(info))) {
> +		printk(KERN_ERR "uvesafb: vbe_init() failed with %d\n", err);
> +		goto out;
> +	}
> +
> +	info->fbops = &uvesafb_ops;
> +
> +	i = uvesafb_vbe_init_mode(info);
> +	if (i < 0) {
> +		err = -EINVAL;
> +		goto out;
> +	} else {
> +		mode = &par->vbe_modes[i];
> +	}
> +
> +	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
> +		err = -ENXIO;
> +		goto out;
> +	}
> +
> +	uvesafb_init_info(info, mode);
> +
> +	if (!request_mem_region(info->fix.smem_start, info->fix.smem_len,
> +	    "uvesafb")) {
> +		printk(KERN_WARNING "uvesafb: cannot reserve video memory at "
> +		       "0x%lx\n", info->fix.smem_start);
> +		/* We cannot make this fatal. Sometimes this comes from magic
> +		   spaces our resource handlers simply don't know about. */

so...  what happens?  The driver starts altering mrmory regions which it
doesn't own?

> +	}
> +
> +	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
> +
> +	if (!info->screen_base) {
> +		printk(KERN_ERR
> +		       "uvesafb: abort, cannot ioremap 0x%x bytes of video "
> +		       "memory at 0x%lx\n",
> +		       info->fix.smem_len, info->fix.smem_start);
> +		err = -EIO;
> +		goto out_mem;
> +	}
> +
> +	if (!request_region(0x3c0, 32, "uvesafb")) {
> +		printk(KERN_ERR "uvesafb: request region 0x3c0-0x3e0 failed\n");
> +		err = -EIO;
> +		goto out_unmap;
> +	}
> +
> +	uvesafb_init_mtrr(info);
> +	platform_set_drvdata(dev, info);
> +
> +	if (register_framebuffer(info) < 0) {
> +		printk(KERN_ERR
> +		       "uvesafb: failed to register framebuffer device\n");
> +		err = -EINVAL;
> +		goto out_reg;
> +	}
> +
> +	printk(KERN_INFO "uvesafb: framebuffer at 0x%lx, mapped to 0x%p, "
> +		       "using %dk, total %dk\n", info->fix.smem_start,
> +		       info->screen_base, info->fix.smem_len/1024,
> +		       par->vbe_ib.total_memory * 64);
> +	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
> +		       info->fix.id);
> +
> +	uvesafb_create_sysfs(&dev->dev, info);
> +	return 0;
> +
> +out_reg:
> +	release_region(0x3c0, 32);
> +out_unmap:
> +	iounmap(info->screen_base);
> +out_mem:
> +	release_mem_region(info->fix.smem_start, info->fix.smem_len);
> +	if (!list_empty(&info->modelist))
> +		fb_destroy_modelist(&info->modelist);
> +	fb_destroy_modedb(info->monspecs.modedb);
> +	fb_dealloc_cmap(&info->cmap);
> +out:
> +	if (par->vbe_modes)
> +		kfree(par->vbe_modes);
> +
> +	framebuffer_release(info);
> +	return err;
> +}
>
> ...
>
> +#ifndef MODULE
> +static int __devinit uvesafb_setup(char *options)
> +{
> +	char *this_opt;
> +
> +	if (!options || !*options)
> +		return 0;
> +
> +	while ((this_opt = strsep(&options, ",")) != NULL) {
> +		if (!*this_opt) continue;
> +
> +		if (!strcmp(this_opt, "redraw"))
> +			ypan = 0;
> +		else if (!strcmp(this_opt, "ypan"))
> +			ypan = 1;
> +		else if (!strcmp(this_opt, "ywrap"))
> +			ypan = 2;
> +		else if (!strcmp(this_opt, "vgapal"))
> +			pmi_setpal = 0;
> +		else if (!strcmp(this_opt, "pmipal"))
> +			pmi_setpal = 1;
> +		else if (!strncmp(this_opt, "mtrr:", 5))
> +			mtrr = simple_strtoul(this_opt+5, NULL, 0);
> +		else if (!strcmp(this_opt, "nomtrr"))
> +			mtrr = 0;
> +		else if (!strcmp(this_opt, "nocrtc"))
> +			nocrtc = 1;
> +		else if (!strcmp(this_opt, "noedid"))
> +			noedid = 1;
> +		else if (!strcmp(this_opt, "noblank"))
> +			blank = 0;
> +		else if (!strncmp(this_opt, "vtotal:", 7))
> +			vram_total = simple_strtoul(this_opt + 7, NULL, 0);
> +		else if (!strncmp(this_opt, "vremap:", 7))
> +			vram_remap = simple_strtoul(this_opt + 7, NULL, 0);
> +		else if (!strncmp(this_opt, "maxhf:", 6))
> +			maxhf = simple_strtoul(this_opt + 6, NULL, 0);
> +		else if (!strncmp(this_opt, "maxvf:", 6))
> +			maxvf = simple_strtoul(this_opt + 6, NULL, 0);
> +		else if (!strncmp(this_opt, "maxclk:", 7))
> +			maxclk = simple_strtoul(this_opt + 7, NULL, 0);
> +		else if (!strncmp(this_opt, "vbemode:", 8))
> +			vbemode = simple_strtoul(this_opt + 8, NULL,0);
> +		else if (this_opt[0] >= '0' && this_opt[0] <= '9') {
> +			mode_option = this_opt;
> +		} else {
> +			printk(KERN_WARNING
> +			       "uvesafb: unrecognized option %s\n", this_opt);
> +		}
> +	}
> +
> +	return 0;
> +}
> +#endif /* !MODULE */

The #ifdef MODULE is unpleasing.  Can we use module_param() here?  That'll
work for both modular and non-modular case.

> +#define uvesafb_free(task)					\
> +do {								\
> +	if (task) {						\
> +		if (task->done)					\
> +			kfree(task->done);			\
> +		kfree(task);					\
> +		task = NULL;					\
> +	}							\
> +} while(0)

I don't think this need to be a macro?  Code should be written in C unless
there is some reason why it _must_ be a macro.

Oh, it sneakily zeroes a variable within the caller's context.  Ow.  Can
we not do that please?  Someone who is reading this code will see a call to
a "function" called uvesafb_free() and the last thing they will expect is
that "function" magically zeroed out a local variable.

> +#define uvesafb_reset(task)					\
> +do {								\
> +	struct completion *cpl = task->done;			\
> +	memset(task, 0, sizeof(struct uvesafb_ktask));		\
> +	task->done = cpl;					\
> +} while(0)							\

This can be a regular C function.

> +static int uvesafb_exec(struct uvesafb_ktask *tsk);
> +
> +#define UVESAFB_NEED_EXACT_RES		1
> +#define UVESAFB_NEED_EXACT_DEPTH	2
> +
> +struct uvesafb_par {
> +	struct vbe_ib vbe_ib;		/* VBE Info Block */
> +	struct vbe_mode_ib *vbe_modes;	/* list of supported VBE modes */
> +	int vbe_modes_cnt;
> +
> +	u8 nocrtc;
> +	u8 ypan;			/* 0 - nothing, 1 - ypan, 2 - ywrap */
> +	u8 pmi_setpal;			/* pmi for palette changes */
> +	u16  *pmi_base;			/* protected mode interface location */
> +	void (*pmi_start)(void);
> +	void (*pmi_pal)(void);
> +
> +	u8 *vbe_state_orig;		/* original hardware state, before the driver was loaded */
> +	u8 *vbe_state_saved;		/* state saved by fb_save_state */
> +	int vbe_state_size;
> +	atomic_t ref_count;
> +
> +	int mode_idx;
> +	struct vbe_crtc_ib crtc;
> +};
> +
> +#endif

A comment on the endif would be nice.

> +#endif /* _UVESAFB_H */

