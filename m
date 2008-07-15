Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbYGOX7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbYGOX7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYGOX67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:58:59 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:33831 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYGOX66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:58:58 -0400
From: Nathan Lynch <ntl@pobox.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, roland@redhat.com
Subject: AT_BASE_PLATFORM (v2)
Date: Tue, 15 Jul 2008 18:58:49 -0500
Message-Id: <1216166331-14810-1-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.5.5
X-Pobox-Relay-ID: FCE3F22C-52C9-11DD-936A-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Background:
Some IBM POWER-based systems have the ability to run in a
"compatibility" mode which mostly appears to the OS as a different
processor from the actual hardware.  This feature of the platform is
useful for live partition migration and for backwards compatibility
with old kernels on new hardware.  For example, a Power6 system may
appear to be a Power5+, which makes the AT_PLATFORM value "power5+".

Problem:
Booting a system in a compatibility mode means that ld.so may load
libraries that are inappropriately tuned for the real
microarchitecture, and apps that use JIT techniques do not have the
right information for generating tuned code.  While the AT_PLATFORM
auxiliary vector entry correctly indicates the ISA supported, it does
not accurately reflect the underlying microarchitecture in this case,
and there is no good way for userspace to get this information.

Proposed solution:
Add an AT_BASE_PLATFORM auxiliary vector entry which indicates the
microarchitecture.  This entry uses the same string format as
AT_PLATFORM, and is readily usable by ld.so and other applications.

Other solutions that have been suggested but found wanting:

- Use a bit in AT_HWCAP to indicate compat mode -- this is not
expressive enough.  It's not possible to derive the microarchitecture
from the combination of AT_PLATFORM's value and a single bit.

- Use dsocaps -- this seems to be a ld.so-specific interface and not
easily usable by other programs.  ld.so/glibc is not the only program
that can use knowledge of the microarchitecture.

The following two patches:
- add the base support to binfmt_elf.c for AT_BASE_PLATFORM
- implement AT_BASE_PLATFORM for powerpc

Changes since v1:
- increment AT_VECTOR_SIZE_BASE
- define AT_BASE_PLATFORM in generic code instead of powerpc
