Return-Path: <linux-kernel-owner+w=401wt.eu-S1762452AbYBFA7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762452AbYBFA7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbYBFA7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:59:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36180 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbYBFA7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:59:16 -0500
Date: Tue, 5 Feb 2008 16:58:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH,RESEND] Basic braille screen reader support
Message-Id: <20080205165853.561d5f3d.akpm@linux-foundation.org>
In-Reply-To: <20080205220054.GD4394@implementation>
References: <20080204031842.GE4439@implementation>
	<20080205220054.GD4394@implementation>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 22:00:54 +0000
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> This adds a minimalistic braille screen reader support.
> This is meant to be used by blind people e.g. on boot failures or when /
> cannot be mounted etc and thus the userland screen readers can not work.

Could you feed it through scritps/checkpatch.pl please?  That finds a lot
of trivial stuff which we'd prefer be fixed.

> +#define beep(freq) do { if (sound) kd_mksound(freq, HZ/10); } while(0)

This can (and hence should!) be impemented in a C function (I think?).

> +
> +/* mini console */
> +#define WIDTH 40
> +#define BRAILLE_KEY KEY_INSERT
> +static u16 console_buf[WIDTH];
> +static int console_cursor = 0;

Unneeded initialisation (checkpatch will tell you about this)

> +/* mini view of VC */
> +static int vc_x, vc_y, lastvc_x, lastvc_y;
> +
> +/* show console ? (or show VC) */
> +static int console_show = 1;
> +/* pending newline ? */
> +static int console_newline = 1;
> +static int lastVC = -1;
> +
> +static struct console *braille_co;
> +
> +/* Very VisioBraille-specific */
> +static void braille_write(u16 *buf)
> +{
> +	static u16 lastwrite[WIDTH];
> +	unsigned char data[1 + 1 + 2*WIDTH + 2 + 1], csum = 0, *c;
> +	u16 out;
> +	int i;
> +
> +	if (!braille_co)
> +		return;
> +
> +	if (!memcmp(lastwrite, buf, WIDTH * sizeof(*buf)))
> +		return;
> +	memcpy(lastwrite, buf, WIDTH * sizeof(*buf));

`lastwrite' is a kernel-wide singleton and hence at least needs some
locking protecting its consistency.

If this is a single-opener-only device then I _guess_ this approach is OK. 
If not, `lastwrite' really should be some dynamically-allocated, per-open thing,
presumably accessed by file.private_data.

> +#define SOH 1
> +#define STX 2
> +#define ETX 2
> +#define EOT 4
> +#define ENQ 5
> +	data[0] = STX;
> +	data[1] = '>';
> +	csum ^= '>';
> +	c = &data[2];
> +	for (i=0; i<WIDTH; i++) {
> +		out = buf[i];
> +		if (out >= 0x100)
> +			out = '?';
> +		else if (out == 0x00)
> +			out = ' ';
> +		csum ^= out;
> +		if (out <= 0x05) {
> +			*c++ = SOH;
> +			out |= 0x40;
> +		}
> +		*c++ = out;
> +	}
> +
> +	if (csum <= 0x05) {
> +		*c++ = SOH;
> +		csum = 0x40;
> +	}
> +	*c++ = csum;
> +	*c++ = ETX;
> +
> +	serial8250_console.write(braille_co, data, c - data);
> +}

hm.  Is it appropriate that this driver wire itself directly into
serial8250?  What if the screen reader is attached to some other sort of
uart, or a terminal server, or...

Maybe this all should be implemented as a line discipline, or something
like that?

> +/*
> + * Link to keyboard
> + */
> +
> +static int keyboard_notifier_call(struct notifier_block *blk, unsigned long code, void *_param)
> +{
> +	struct keyboard_notifier_param *param = _param;
> +	struct vc_data *vc = param->vc;
> +	int ret = NOTIFY_OK;
> +
> +	if (!param->down)
> +		return ret;
> +
> +	switch (code) {
> +		case KBD_KEYCODE:

Maybe Dmitry and Jiri would have time to review this code?

> +static struct notifier_block keyboard_notifier_block = {
> +	.notifier_call = keyboard_notifier_call,
> +};
> +
> +static int vt_notifier_call(struct notifier_block *blk, unsigned long code, void *_param)
> +{
> +	struct vt_notifier_param *param = _param;
> +	struct vc_data *vc = param->vc;
> +	switch (code) {
> +		case VT_ALLOCATE:
> +			break;
> +		case VT_DEALLOCATE:
> +			break;
> +		case VT_WRITE:
> +		{
> +			unsigned char c = param->c;
> +			switch (c) {
> +				case '\b':
> +				case 127:
> +					if (console_cursor > 0) {
> +						console_cursor--;
> +						console_buf[console_cursor] = ' ';
> +					}
> +					break;
> +				case '\n':
> +				case '\v':
> +				case '\f':
> +				case '\r':
> +					console_newline = 1;
> +					break;
> +				case '\t':
> +					c = ' ';
> +					/* Fallthrough */
> +				default:
> +					if (c < 32)
> +						/* Ignore other control sequences */
> +						break;
> +					if (console_newline) {
> +						memset(console_buf, 0, sizeof(console_buf));
> +						console_cursor = 0;
> +						console_newline = 0;
> +					}
> +					if (console_cursor == WIDTH)
> +						memmove(console_buf, &console_buf[1], (WIDTH-1) * sizeof(*console_buf));
> +					else
> +						console_cursor++;
> +					console_buf[console_cursor-1] = c;
> +					break;
> +			}
> +			if (console_show)
> +				braille_write(console_buf);
> +			else {
> +				vc_maybe_cursor_moved(vc);
> +				vc_refresh(vc);
> +			}
> +			break;
> +		}
> +		case VT_UPDATE:
> +			/* Maybe a VT switch, flush */
> +			if (console_show) {
> +				if (vc->vc_num != lastVC) {
> +					lastVC = vc->vc_num;
> +					memset(console_buf, 0, sizeof(console_buf));
> +					console_cursor = 0;
> +					braille_write(console_buf);
> +				}
> +			} else {
> +				vc_maybe_cursor_moved(vc);
> +				vc_refresh(vc);
> +			}
> +			break;
> +	}
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block vt_notifier_block = {
> +	.notifier_call = vt_notifier_call,
> +};
> +
> +/*
> + * Link to serial console
> + */
> +
> +static int __init braille_console_setup(struct console *co, char *options)
> +{
> +	int ret = 0;
> +	if (co->index == -1)
> +		co->index = 0;
> +#ifndef MODULE
> +	ret = serial8250_console.setup(co, options);
> +	if (ret < 0)
> +		return ret;
> +#endif

That's pretty ungainly.  Again, if we had some clear spearation between the
protocol layer and the device-driver layer and some way of binding them
under userspace control (like a line discipline), all this would get better.

> +	braille_co = co;
> +	return ret;
> +}
> +
> +static struct console braille_console = {
> +	.name		= "brl",
> +	.setup		= braille_console_setup,
> +	.flags		= CON_PRINTBUFFER,
> +	.index		= -1,
> +};
> +
>
> ...
>
> diff -urN linux-2.6.24-orig/drivers/a11y/Kconfig linux-2.6.24-perso/drivers/a11y/Kconfig
> --- linux-2.6.24-orig/drivers/a11y/Kconfig	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.24-perso/drivers/a11y/Kconfig	2008-02-04 01:54:36.000000000 +0000
> @@ -0,0 +1,22 @@
> +menuconfig A11Y
> +	bool "Accessibility support"

That's cute, but perhaps we should be boring and call it
CONFIG_ACCESSIBILITY.  That would be more accessible ;)

> +	---help---
> +	  Enable a submenu where accessibility items may be enabled.
> +
> +	  If unsure, say N.
> +
> +if A11Y
> +config A11Y_BRAILLE_CONSOLE

And that would get very lengthy.

> +	tristate "Console on braille device"
> +	depends on SERIAL_8250_CONSOLE
> +	---help---
> +	  Enables console output on a braille device connected to a 8250
> +	  serial port. For now only the VisioBraille device is supported.
> +
> +	  To actually enable it, you need to pass option
> +	  console=brl0
> +	  to the kernel. Options are the same as for serial console.
> +
> +	  If unsure, say N.
> +
> +endif # A11Y

