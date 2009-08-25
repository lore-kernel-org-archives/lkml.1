Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZHYKmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZHYKmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZHYKmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:42:07 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:42034 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZHYKmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=SfRMVc7U5vb7KRaXyAE7IuHJHMuq/O0sWb/n3VxU7i+D7O7894pn5HHF4gs6skJ940
         Hu7uHDHjAsks8hC9zcH11MI2AfA6HCZ0JAg3eueMkY2GKQwnU8/yPnvs0VvJoz1nJXZ+
         fYHC826LrNHQ3heb1wHk3KXoLdTBTuOdEqjss=
MIME-Version: 1.0
Date: Tue, 25 Aug 2009 16:12:07 +0530
Message-ID: <6d53329e0908250342g2cfb73f6v90f73c283c0d391c@mail.gmail.com>
Subject: ARM + jprobes/kretprobes SEGV/hangs/OOPS in 2.6.29 kernel
From: venki kaps <venkiece2005@gmail.com>
To: sagar.abhishek@gmail.com, nico@marvell.com, jkenisto@us.ibm.com,
       rmk+kernel@arm.linux.org.uk, linux@arm.linux.org.uk,
       linux-arm@vger.kernel.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been tracing kernel system call information using
the Kprobes/jprobes/kretprobes implementation in the 2.6.29 kernel on
ARM architecture.
Although the mainline kprobe/jprobe/kretprobe examples are working
fine (do_fork),
I have been facing some issues while running my own jprobe/kretprobe tests.

For instance, when I am planting jprobe at
do_execve/sys_open/sys_close/sys_read/sys_write/,
after registration of probe, segmentation fault is getting generated.
The following is my code snapshot-

static int
jdo_execve(char * filename,
                char __user *__user *argv,
                char __user *__user *envp,
                struct pt_regs * regs)

{
		jprobe_return();
		return 0;
}

static struct jprobe my_jprobe = {
	.entry                          = jdo_execve,
                .kp = {
                         .symbol_name    = "do_execve",
               },

};

static int __init jprobe_init(void) {
	
	if ((register_jprobe(&my_jprobe)) < 0) {
		printk("%s %d,register_jprobe failed, returned\n", __FILE__, __LINE__);
		return -1;
	}
	printk("%s %d,Planted jprobe at %p, handler addr %p\n", __FILE__, __LINE__,
		 my_jprobe.kp.addr, my_jprobe.entry);

	return 0;
}

static void __exit jprobe_exit(void) {
	unregister_jprobe(&my_jprobe);
	printk("%s %d,jprobe unregistered\n", __FILE__, __LINE__);
}

And also system hangs for sys_open/sys_close/sys_read/sys_write with
jprobes/kretprobes
but there are no issues with kprobes.

Query:
=====
	- Are there any limitations for jptobes/kretporbes in mainline kernel for ARM?
	- Why it works for only do_fork and why not for others
(do_execve/sys_open/sys_close/sys_read/sys_write)?
	- Is it required any additional setup to achieve this?

Please give your valuable comments.

Thanks in advance.

Best regards,
Venkappa
