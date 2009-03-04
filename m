Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZCDKNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZCDKNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZCDKNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:13:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40302 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZCDKNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:13:15 -0500
Date: Wed, 4 Mar 2009 11:12:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] fs: make simple_read_from_buffer conventional
Message-ID: <20090304101201.GA31239@elte.hu>
References: <20090304024921.153061228@goodmis.org> <20090304025251.015368537@goodmis.org> <20090303193501.0055e329.akpm@linux-foundation.org> <alpine.DEB.2.00.0903032242180.6862@gandalf.stny.rr.com> <20090304044614.GL32284@mit.edu> <alpine.DEB.2.00.0903040002180.7995@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903040002180.7995@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Impact: have simple_read_from_buffer conform to standards
> 
> It was brought to my attention by Andrew Morton, Theodore Tso,
> and H. Peter Anvin that a read from userspace should only return
> -EFAULT if nothing was actually read.
> 
> Looking at the simple_read_from_buffer I noticed that this function
> does not conform to that rule. This patch fixes that function.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 49b4409..6a72298 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -525,14 +525,20 @@ ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
>  				const void *from, size_t available)
>  {
>  	loff_t pos = *ppos;
> +	size_t ret;
> +
>  	if (pos < 0)
>  		return -EINVAL;
>  	if (pos >= available)
>  		return 0;
>  	if (count > available - pos)
>  		count = available - pos;
> -	if (copy_to_user(to, from + pos, count))
> -		return -EFAULT;
> +	ret = copy_to_user(to, from + pos, count);
> +	if (ret) {
> +		if (ret == count)
> +			return -EFAULT;
> +		count -= ret;
> +	}

Btw., the git grep result below shows 160 usage sites all across 
the kernel, so this bug affects a lot of existing debugfs users.

	Ingo

arch/cris/kernel/profile.c:	ret = simple_read_from_buffer(buf, count, ppos, sample_buffer,
arch/ia64/kernel/salinfo.c:	return simple_read_from_buffer(buffer, count, ppos, buf, bufsize);
arch/powerpc/kernel/proc_ppc64.c:	return simple_read_from_buffer(buf, nbytes, ppos, dp->data, dp->size);
arch/powerpc/platforms/cell/spufs/file.c:	ret = simple_read_from_buffer(buf, len, ppos, attr->get_buf, size);
arch/powerpc/platforms/cell/spufs/file.c:	return simple_read_from_buffer(buffer, size, pos, local_store,
arch/powerpc/platforms/cell/spufs/file.c:	return simple_read_from_buffer(buffer, size, pos,
arch/powerpc/platforms/cell/spufs/file.c:	return simple_read_from_buffer(buffer, size, pos,
arch/powerpc/platforms/cell/spufs/file.c:	return simple_read_from_buffer(buf, len, pos, &data, sizeof data);
arch/powerpc/platforms/cell/spufs/file.c:	return simple_read_from_buffer(buf, len, pos, &data, sizeof data);
arch/powerpc/platforms/cell/spufs/file.c:	return simple_read_from_buffer(buf, len, pos, &data,
arch/powerpc/platforms/cell/spufs/file.c:	return simple_read_from_buffer(buf, len, pos, &info,
arch/powerpc/platforms/cell/spufs/file.c:	return simple_read_from_buffer(buf, len, pos, &info,
arch/s390/hypfs/inode.c:	ret = simple_read_from_buffer(buf, count, &offset, data, strlen(data));
arch/um/drivers/mmapper_kern.c:	return simple_read_from_buffer(buf, count, ppos, v_buf, mmapper_size);
arch/x86/xen/debugfs.c:	return simple_read_from_buffer(buf, len, ppos, file->private_data, size);
drivers/acpi/system.c:	res = simple_read_from_buffer(buffer, count, ppos, dsdt, dsdt->length);
drivers/acpi/system.c:	res = simple_read_from_buffer(buffer, count, ppos, fadt, fadt->length);
drivers/char/nwflash.c:	ret = simple_read_from_buffer(buf, size, ppos, (void *)FLASH_BASE, gbFlashSize);
drivers/idle/i7300_idle.c:	return simple_read_from_buffer(ubuf, count, off, buf, len);
drivers/infiniband/hw/ipath/ipath_fs.c:	return simple_read_from_buffer(buf, count, ppos, &ipath_stats,
drivers/infiniband/hw/ipath/ipath_fs.c:	return simple_read_from_buffer(buf, count, ppos, &counters,
drivers/isdn/hysdn/hysdn_procconf.c:	return simple_read_from_buffer(buf, count, off, cp, strlen(cp));
drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c:	return simple_read_from_buffer(buf, count, offset, stc_firmware, 8192);
drivers/media/video/cafe_ccic.c:	return simple_read_from_buffer(buf, count, ppos, cafe_debug_buf,
drivers/media/video/cafe_ccic.c:	return simple_read_from_buffer(buf, count, ppos, cafe_debug_buf,
drivers/net/wimax/i2400m/debugfs.c:	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
drivers/net/wimax/i2400m/debugfs.c:	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
drivers/net/wireless/airo.c:	return simple_read_from_buffer(buffer, len, offset, priv->rbuffer,
drivers/net/wireless/ath5k/debug.c:	return simple_read_from_buffer(user_buf, count, ppos, buf, 19);
drivers/net/wireless/ath5k/debug.c:	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
drivers/net/wireless/ath5k/debug.c:	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
drivers/net/wireless/ath9k/debug.c:	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
drivers/net/wireless/ath9k/debug.c:	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
drivers/net/wireless/b43/debugfs.c:	ret = simple_read_from_buffer(userbuf, count, ppos,
drivers/net/wireless/b43legacy/debugfs.c:	ret = simple_read_from_buffer(userbuf, count, ppos,
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
drivers/net/wireless/iwlwifi/iwl-agn-rs.c:	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
drivers/net/wireless/iwlwifi/iwl-agn-rs.c:	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
drivers/net/wireless/iwlwifi/iwl-debugfs.c:	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
drivers/net/wireless/iwlwifi/iwl-debugfs.c:	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
drivers/net/wireless/iwlwifi/iwl-debugfs.c:	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
drivers/net/wireless/iwlwifi/iwl-debugfs.c:	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
drivers/net/wireless/iwlwifi/iwl-debugfs.c:	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
drivers/net/wireless/iwlwifi/iwl-debugfs.c:	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
drivers/net/wireless/libertas/debugfs.c:	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
drivers/net/wireless/libertas/debugfs.c:	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
drivers/net/wireless/libertas/debugfs.c:	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
drivers/net/wireless/libertas/debugfs.c:	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
drivers/net/wireless/libertas/debugfs.c:	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
drivers/net/wireless/libertas/debugfs.c:	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
drivers/net/wireless/libertas/debugfs.c:	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
drivers/net/wireless/libertas/debugfs.c:	res = simple_read_from_buffer(userbuf, count, ppos, p, pos);
drivers/oprofile/oprofilefs.c:	return simple_read_from_buffer(buf, count, offset, str, strlen(str));
drivers/oprofile/oprofilefs.c:	return simple_read_from_buffer(buf, count, offset, tmpbuf, maxlen);
drivers/pci/hotplug/cpqphp_sysfs.c:	return simple_read_from_buffer(buf, nbytes, ppos, dbg->data, dbg->size);
drivers/s390/char/vmcp.c:	ret = simple_read_from_buffer(buff, count, ppos,
drivers/s390/char/zcore.c:	return simple_read_from_buffer(buf, count, ppos, filp->private_data,
drivers/scsi/lpfc/lpfc_debugfs.c:	return simple_read_from_buffer(buf, nbytes, ppos, debug->buffer,
drivers/usb/gadget/atmel_usba_udc.c:	ret = simple_read_from_buffer(buf, nbytes, ppos,
drivers/usb/host/ehci-dbg.c:	ret = simple_read_from_buffer(user_buf, len, offset,
drivers/usb/host/ohci-dbg.c:	ret = simple_read_from_buffer(user_buf, len, offset,
drivers/usb/host/uhci-debug.c:	return simple_read_from_buffer(buf, nbytes, ppos, up->data, up->size);
drivers/usb/misc/idmouse.c:	result = simple_read_from_buffer(buffer, count, ppos,
drivers/usb/mon/mon_stat.c:	return simple_read_from_buffer(buf, nbytes, ppos, sp->str, sp->slen);
drivers/video/mbx/mbxdebugfs.c:	return  simple_read_from_buffer(userbuf, count, ppos,
drivers/video/mbx/mbxdebugfs.c:	return  simple_read_from_buffer(userbuf, count, ppos,
drivers/video/mbx/mbxdebugfs.c:	return  simple_read_from_buffer(userbuf, count, ppos,
drivers/video/mbx/mbxdebugfs.c:	return  simple_read_from_buffer(userbuf, count, ppos,
drivers/video/mbx/mbxdebugfs.c:	return  simple_read_from_buffer(userbuf, count, ppos,
drivers/video/mbx/mbxdebugfs.c:	return  simple_read_from_buffer(userbuf, count, ppos,
fs/binfmt_misc.c:	res = simple_read_from_buffer(buf, nbytes, ppos, page, strlen(page));
fs/binfmt_misc.c:	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
fs/configfs/file.c:	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
fs/debugfs/file.c:	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
fs/debugfs/file.c:	return simple_read_from_buffer(user_buf, count, ppos, blob->data,
fs/dlm/debug_fs.c:	rv = simple_read_from_buffer(userbuf, count, ppos, debug_buf, pos);
fs/fuse/control.c:	return simple_read_from_buffer(buf, len, ppos, tmp, size);
fs/libfs.c: * simple_read_from_buffer - copy data from the buffer to user space
fs/libfs.c: * The simple_read_from_buffer() function reads up to @count bytes from the
fs/libfs.c:ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
fs/libfs.c:	return simple_read_from_buffer(buf, size, pos, ar->data, ar->size);
fs/libfs.c:	ret = simple_read_from_buffer(buf, len, ppos, attr->get_buf, size);
fs/libfs.c:EXPORT_SYMBOL(simple_read_from_buffer);
fs/ocfs2/dlm/dlmdebug.c:	return simple_read_from_buffer(buf, nbytes, ppos, db->buf, db->len);
fs/ocfs2/localalloc.c:	ret = simple_read_from_buffer(userbuf, count, ppos, buf, written);
fs/ocfs2/stack_user.c:	ret = simple_read_from_buffer(buf, count, ppos,
fs/proc/base.c:		length = simple_read_from_buffer(buf, count, ppos, (char *)page, length);
fs/proc/base.c:	return simple_read_from_buffer(buf, count, ppos, buffer, len);
fs/proc/base.c:	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
fs/proc/base.c:	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
fs/proc/base.c:	return simple_read_from_buffer(buf, count, ppos, buffer, len);
fs/proc/base.c:		err = simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
fs/proc/base.c:		length = simple_read_from_buffer(buf, count, ppos, p, length);
fs/proc/base.c:		ret = simple_read_from_buffer(buf, count, ppos, buffer, len);
fs/sysfs/file.c:	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
include/linux/fs.h:extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
ipc/mqueue.c:	ret = simple_read_from_buffer(u_data, count, off, buffer,
kernel/cgroup.c:	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
kernel/cgroup.c:	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
kernel/configs.c:	return simple_read_from_buffer(buf, len, offset,
kernel/cpuset.c:	retval = simple_read_from_buffer(buf, nbytes, ppos, page, s - page);
kernel/kprobes.c:	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
kernel/rcupreempt_trace.c:	bcount = simple_read_from_buffer(buffer, count, ppos,
kernel/rcupreempt_trace.c:	bcount = simple_read_from_buffer(buffer, count, ppos,
kernel/rcupreempt_trace.c:	bcount = simple_read_from_buffer(buffer, count, ppos,
kernel/res_counter.c:	return simple_read_from_buffer((void __user *)userbuf, nbytes,
kernel/trace/blktrace.c:	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
kernel/trace/ftrace.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
kernel/trace/ring_buffer.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
kernel/trace/trace.c:	count = simple_read_from_buffer(ubuf, count, ppos, mask_str, NR_CPUS+1);
kernel/trace/trace.c:	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
kernel/trace/trace.c:	return simple_read_from_buffer(ubuf, cnt, ppos,
kernel/trace/trace.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
kernel/trace/trace.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
kernel/trace/trace.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
kernel/trace/trace.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
kernel/trace/trace.c:	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
kernel/trace/trace.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
kernel/trace/trace.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
kernel/trace/trace_events.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
kernel/trace/trace_events.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
kernel/trace/trace_events.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
kernel/trace/trace_events.c:		r = simple_read_from_buffer(ubuf, cnt, ppos,
kernel/trace/trace_events.c:	r = simple_read_from_buffer(ubuf, cnt, ppos,
kernel/trace/trace_stack.c:	return simple_read_from_buffer(ubuf, count, ppos, buf, r);
kernel/trace/trace_sysprof.c:	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
net/mac80211/debugfs.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
net/mac80211/debugfs.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
net/mac80211/debugfs_key.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
net/mac80211/debugfs_key.c:	return simple_read_from_buffer(userbuf, count, ppos, alg, strlen(alg));
net/mac80211/debugfs_key.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
net/mac80211/debugfs_key.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
net/mac80211/debugfs_key.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
net/mac80211/debugfs_key.c:	res = simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
net/mac80211/debugfs_netdev.c:		ret = simple_read_from_buffer(userbuf, count, ppos, buf, ret);
net/mac80211/debugfs_sta.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
net/mac80211/debugfs_sta.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
net/mac80211/debugfs_sta.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
net/mac80211/debugfs_sta.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
net/mac80211/debugfs_sta.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
net/mac80211/debugfs_sta.c:	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
net/mac80211/rate.c:	return simple_read_from_buffer(userbuf, count, ppos,
net/sunrpc/sysctl.c:	return simple_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
security/selinux/selinuxfs.c:	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
security/selinux/selinuxfs.c:	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
security/selinux/selinuxfs.c:	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
security/selinux/selinuxfs.c:	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
security/selinux/selinuxfs.c:	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
security/selinux/selinuxfs.c:	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
security/selinux/selinuxfs.c:	ret = simple_read_from_buffer(buf, count, ppos, page, length);
security/selinux/selinuxfs.c:	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
security/selinux/selinuxfs.c:		ret = simple_read_from_buffer(buf, count, ppos, page, ret);
security/selinux/selinuxfs.c:	ret = simple_read_from_buffer(buf, count, ppos, con, len);
security/selinux/selinuxfs.c:	rc = simple_read_from_buffer(buf, count, ppos, page, len);
security/selinux/selinuxfs.c:	rc = simple_read_from_buffer(buf, count, ppos, page, len);
security/selinux/selinuxfs.c:	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
security/smack/smackfs.c:	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
security/smack/smackfs.c:	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
security/smack/smackfs.c:		rc = simple_read_from_buffer(buf, cn, ppos,
security/smack/smackfs.c:		rc = simple_read_from_buffer(buf, cn, ppos, smack, asize);
sound/soc/soc-core.c:		ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
