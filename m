Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbYCEPaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbYCEPaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYCEPaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:30:22 -0500
Received: from hall.aurel32.net ([88.191.38.19]:36897 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYCEPaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:30:21 -0500
Date: Wed, 5 Mar 2008 16:30:20 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
To: linux-kernel@vger.kernel.org
Cc: gcc@gcc.gnu.org
Subject: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080305153020.GA24631@volta.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Mailer: Mutt 1.5.17+20080114 (2008-01-14)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Since version 4.3, gcc changed its behaviour concerning the x86/x86-64 
ABI and the direction flag, that is it now assumes that the direction 
flag is cleared at the entry of a function and it doesn't clear once 
more if needed.

This causes some problems with the Linux kernel which does not clear
the direction flag when entering a signal handler. The small code below
(for x86-64) demonstrates that. 

If the signal handler is using code that need the direction flag cleared
(for example bzero() or memset()), the code is incorrectly executed.

I guess this has to be fixed on the kernel side, but also gcc-4.3 could
revert back to the old behaviour, that is clearing the direction flag
when entering a routine that touches it until most people are running a
fixed kernel.

Kind regards,
Aurelien

[1] http://gcc.gnu.org/gcc-4.3/changes.html


#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>

void handler(int signal) {
	uint64_t rflags;
	
	asm volatile("pushfq ; popq %0" : "=g" (rflags));

	if (rflags & (1 << 10))
		printf("DF = 1\n");
	else
		printf("DF = 0\n");
}

int main() {
	signal(SIGUSR1, handler);

	while(1)
	{
		asm volatile("std\r\n");
	}

	return 0;
}

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
