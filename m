Return-Path: <linux-kernel-owner+w=401wt.eu-S1161198AbXBUKBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161198AbXBUKBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161202AbXBUKBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:01:16 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55225 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161198AbXBUKBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:01:03 -0500
Message-ID: <45DC184C.3080600@hitachi.com>
Date: Wed, 21 Feb 2007 19:00:44 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared
    memory
References: <45DAC32B.4030603@hitachi.com> <45D5B483.3020502@hitachi.com> 
    <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> 
    <18826.1171969097@redhat.com>
In-Reply-To: <18826.1171969097@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for your reply.

David Howells wrote:

>>I think that locking makes codes complex and generates overhead.
>>So I wouldn't like to use lock as far as possible.  I think passing
>>the flag as an extra argument is the simplest implementation to
>>avoid the core file corruption.
> 
> Actually, I don't think the locking is that hard or that complex.
> 
> 	int do_coredump(long signr, int exit_code, struct pt_regs * regs)
> 	{
> 		<setup vars>
> 
> 		down_read(&coredump_settings_sem);
> 
> 		...
> 
> 	fail:
> 		up_read(&coredump_settings_sem);
> 		return retval;
> 	}
> 
> And:
> 
> 	static ssize_t proc_coredump_omit_anon_shared_write(struct file *file,
> 						    const char __user *buf,
> 						    size_t count,
> 						    loff_t *ppos)
> 	{
> 		<setup vars>
> 
> 		down_write(&coredump_settings_sem);
> 
> 		...
> 
> 	out_no_task:
> 		up_write(&coredump_settings_sem);
> 		return ret;
> 	}

Is coredump_setting_sem a global semaphore?  If so, it prevents concurrent
core dumping.  Additionally, while some process is dumped, writing to
coredump_omit_anon_shared of unrelated process will be blocked.

So we should use per process or per mm locking.  But where should we
place the variable for locking?  Because we don't want to increase the
struct size, we might want to add another bit field in mm_struct:

	struct mm_struct {
		...
 		unsigned char dumpable:2;
		unsigned char coredump_in_progress:1;      /* this */
		unsigned char coredump_omit_anon_shared:1;
		...

And we use it to determine whether core dumping is in progress or not:

 	int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	{
 		<setup vars>
 
 		spin_lock(&dump_bits_lock);
		current->mm->coredump_in_progress = 1;
		spin_unlock(&dump_bits_lock);
		...

Additionally:

 	static ssize_t proc_coredump_omit_anon_shared_write(struct file *file,
 						    const char __user *buf,
 						    size_t count,
 						    loff_t *ppos)
 	{
 		<setup vars>

		ret = -EBUSY; 
		spin_lock(&dump_bits_lock);
		if (mm->coredump_in_progress) {
			spin_unlock(&dump_bits_lock);
			goto out;
		}
		mm->coredump_omit_anon_shared = (val != 0);
		spin_unlock(&dump_bits_lock);
		...

Do you think which is better this method or passing argument method
used by my patchset?
Or, are there even better way else?

-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory

