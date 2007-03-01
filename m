Return-Path: <linux-kernel-owner+w=401wt.eu-S965170AbXCAPKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170AbXCAPKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965171AbXCAPKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:10:07 -0500
Received: from il.qumranet.com ([82.166.9.18]:50876 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965170AbXCAPKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:10:06 -0500
Message-ID: <45E6EC49.9050308@qumranet.com>
Date: Thu, 01 Mar 2007 17:07:53 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC][KVM] Adding a signal mask to KVM_RUN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to add a signal mask to kvm, so that when the guest executes, 
the signal mask is temporarily set to some user specified value.  This 
allows signals to be used as a way to interrupt the guest, but without 
requiring signal delivery to the userspace handler (which is what makes 
signals expensive).

The question is how to fit the signal mask to the kvm userspace 
interface (which has a shared kernel/user structure that userspace 
mmaps).  I see several options:

1. Add a __u64 to that structure.  This is the simplest option, but I 
see that signal masks in the kernel/user interface are variable-length 
bitmaps, so this clearly doesn't work well.

2. Add __u32 signal_mask_offset and signal_mask_size members to the 
structure to tell userspace where to store the signal mask (in the same 
shared area).  A disadvantage is that here the kernel tells the user the 
size of the signal mask instead of the other way round as is traditional.

3. Add a separate ioctl to set the signal mask.  A NULL parameter 
disables the signal mask functionality.

I am in favor of the third option, but the existence of three options 
tells me more are possible.

[Just as background, signals are used for the following in our modified 
qemu, the only known public client for kvm:

- interrupt the guest to get timer interrupts
- interrupt the guest on packet arrival
- interrupt the guest on aio completion
- (future) for guest smp, to simulate IPIs]

-- 
error compiling committee.c: too many arguments to function

