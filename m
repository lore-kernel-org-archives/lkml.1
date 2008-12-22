Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYLVQ2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYLVQ2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 11:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYLVQ2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 11:28:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39535 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYLVQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 11:28:44 -0500
Message-ID: <494FC03A.3090208@zytor.com>
Date: Mon, 22 Dec 2008 08:28:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Multiple math errors and SIGFPE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have received a bug report related to the si_code field of siginfo for
SIGFPE.  The FPE_ values are (unfortunately) an enumeration rather than
a bitmask, so we can't just OR them together.  Unfortunately when we get
multiple unmasked exceptions at least on x86 we leave info.si_code to
__SI_FAULT, which means it is returned to userspace as zero.  This
violates POSIX, which states that an si_code <= 0 is a user-generated
signal.

Looking at the code in other architectures, it looks like most of them
prioritize the faults, but still end up with __SI_FAULT|0 if none of the
expected conditions are found (which may not be possible, of course.)
Prioritizing the faults seem like the reasonable thing to do in terms of
 dealing with the multiple unmasked errors problem.

I am wondering if it would make sense to notice the combination
__SI_FAULT|0 or __SI_FAULT and (short)si_code < 0 and force SI_KERNEL
into the user-space code field in the generic code.  I am also wondering
if there is any possibility that there is code out there which relies on
the current, buggy behaviour.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

