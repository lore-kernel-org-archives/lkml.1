Return-Path: <linux-kernel-owner+w=401wt.eu-S1761798AbYB2Und@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761798AbYB2Und (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYB2UnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:43:25 -0500
Received: from gw.goop.org ([64.81.55.164]:33012 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbYB2UnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:43:24 -0500
Message-ID: <47C86D7A.5030608@goop.org>
Date: Fri, 29 Feb 2008 12:39:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>
Subject: bad paravirt/Xen interaction in "x86 - Enhance DEBUG_RODATA support
 - alternatives"
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "x86 - Enhance DEBUG_RODATA support - alternatives" enables 
the kernel for writing by clearing X86_CR0_WP allow privileged writes.  
This won't work in a paravirt environment for two reasons:

   1. the kernel may not be running in ring 0, so writes will still be
      prevented
   2. the hypervisor prevents X86_CR0_WP from being cleared anyway (it
      GPFs the cr0 update)

This crashes on Xen, and it would probably break VMI too.

The only safe way to allow writes is to change the page permissions 
(either on the page itself, or create a temporary writable alias for 
that page).  Perhaps something you could do it with kmap_atomic.

    J
