Return-Path: <linux-kernel-owner+w=401wt.eu-S932762AbXBVAma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbXBVAma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932775AbXBVAma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:42:30 -0500
Received: from sccrmhc12.comcast.net ([204.127.200.82]:48124 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbXBVAm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:42:29 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 19:42:29 EST
Date: Wed, 21 Feb 2007 16:33:09 -0800
From: Deepak Saxena <dsaxena@plexity.net>
To: linux-kernel@vger.kernel.org
Subject: Modprobe as script breaks initramfs kernel?
Message-ID: <20070222003309.GA22471@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We attempted an experiment in cleaning up some modprobe messages during 
initramfs bootup when the modules directory is missing by moving modprobe 
to modprobe-bin and replacing modprobe with the following simple shell script:

#!/bin/sh
# Clean up bootup when modules are not present

if [ -e "/lib/modules/'uname -r'/modules.dep" ] ; then
	/sbin/modprobe-bin $*
else
	exit 0
fi

Running this on any architecture causes a non fatal kernel BUG message
out of the do_pipe() code path everytime modprobe is called.

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000014
c016a5e6
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<c016a5e6>]    Not tainted VLI
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010286   (2.6.18_pro500-pc_target-x86_586 #2) 
eax: 00000000   ebx: bf8f9ae8   ecx: 00000000   edx: c16a00f0
esi: c16f0c80   edi: 00000011   ebp: c16f0bc0   esp: c16e9f40
ds: 007b   es: 007b   ss: 0068   preempt: 00000001
Stack: 00000000 dff64dc0 c13ff580 00000000 ffffffe9 dfe84a40 00000002 c16e8000 
       c169f41c 0808d581 c166b900 c010f5bd c166b934 c169f41c 0808d581 00000000 
       00000004 c16e9fbc bf8f9ae8 c16e9fa8 00000011 c16e8000 c0107737 c16e9fa8 
Call Trace:
 [<c010f5bd>]  [<c0107737>]  [<c01030d7>] <0>Code: c6 c7 44 24 10 e9 ff ff ff 0f 84 1b 02 00 00 e8 91 2e ff ff 85 c0 89 c5 c7 44 24 10 e9 ff ff ff 0f 84 34 02 00 00 a1 d8 75 53 c0 <8b> 40 14 89 04 24 e8 8f ec 00 00 85 c0 89 c3 0f 84 0a 02 00 00 
EIP: [<c016a5e6>]  SS:ESP 0068:c16e9f40
Warning (Oops_read): Code line not seen, dumping what data is available


>>EIP; c016a5e6 <do_pipe+46/2c0>   <=====

>>ebx; bf8f9ae8 <phys_startup_32+bf7f9ae8/c0000000>
>>edx; c16a00f0 <pg0+f220f0/3f880400>
>>esi; c16f0c80 <pg0+f72c80/3f880400>
>>ebp; c16f0bc0 <pg0+f72bc0/3f880400>
>>esp; c16e9f40 <pg0+f6bf40/3f880400>

Trace; c010f5bd <do_page_fault+15d/75a>
Trace; c0107737 <sys_pipe+17/60>
Trace; c01030d7 <syscall_call+7/b>

>>EIP; c016a5e6 <do_pipe+46/2c0>   <=====

I've done a quick skim of the code and don't quite see the issue there.
Can the kernel not handle modprobe as a script that then executes another
process this early in the boot sequence?

Tnx,
~Deepak

ps: Yes, I know this is "fix" to error messages is ugly. :)

-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net

in the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertold Brecht
