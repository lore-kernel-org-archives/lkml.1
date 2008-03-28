Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYC1MgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYC1MgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYC1Mfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:35:54 -0400
Received: from ozlabs.org ([203.10.76.45]:49344 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbYC1Mfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:35:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18412.58902.189124.391104@cargo.ozlabs.ibm.com>
Date: Fri, 28 Mar 2008 23:35:34 +1100
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I have added another commit to the powerpc.git merge branch, so when
you do:

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

you'll get a fix for a bug where the hardware data breakpoint would
sometimes fail to trigger on powerpc, if multiple threads put a
breakpoint on the same address.  The bug has been around for a while
and Michael Ellerman just found the cause and posted a fix.

Thanks,
Paul.

 arch/powerpc/configs/pasemi_defconfig |  142 ++++++++++++++++++++-------------
 arch/powerpc/kernel/process.c         |   10 +-
 2 files changed, 93 insertions(+), 59 deletions(-)

commit a2ceff5e555e664751bc653a4d9b133efa18c742
Author: Michael Ellerman <michael@ellerman.id.au>
Date:   Fri Mar 28 19:11:48 2008 +1100

    [POWERPC] Fix missed hardware breakpoints across multiple threads
    
    There is a bug in the powerpc DABR (data access breakpoint) handling,
    which can result in us missing breakpoints if several threads are trying
    to break on the same address.
    
    The circumstances are that do_page_fault() calls do_dabr(), this clears
    the DABR (sets it to 0) and sets up the signal which will report to
    userspace that the DABR was hit. The do_signal() code will restore the DABR
    value on the way out to userspace.
    
    If we reschedule before calling do_signal(), __switch_to() will check the
    cached DABR value and compare it to the new thread's value, if they match
    we don't set the DABR in hardware.
    
    So if two threads have the same DABR value, and we schedule from one to
    the other after taking the interrupt for the first thread hitting the DABR,
    the second thread will run without the DABR set in hardware.
    
    The cleanest fix is to move the cache update into set_dabr(), that way we
    can't forget to do it.
    
    Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
    Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 5c29934de29ddd7ecd913d83cad28e872f2e8c78
Author: Olof Johansson <olof@lixom.net>
Date:   Tue Mar 25 10:28:26 2008 -0500

    [POWERPC] update pasemi_defconfig
    
    Disable GEN_RTC since it conflicts with the i2c rtc drivers registering,
    besides that keep most of the new defaults.
    
    Signed-off-by: Olof Johansson <olof@lixom.net>
