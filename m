Return-Path: <linux-kernel-owner+w=401wt.eu-S933712AbZJIQAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbZJIQAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933049AbZJIQA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:00:29 -0400
Received: from mail.chelny.ertelecom.ru ([91.144.152.225]:33924 "EHLO
	mail.nchel.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932947AbZJIQA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:00:28 -0400
X-Greylist: delayed 11789 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Oct 2009 12:00:28 EDT
Message-ID: <45934521495c84b6a6cfbd8919d30877.squirrel@mail.chelnydom.ru>
Date: Fri, 9 Oct 2009 16:43:20 +0400
Subject: New rwsem
From: vik@chelnydom.ru
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.7 (-)
X-Spam-Report: Spam detection software, running on the system "mail.nchel.ru", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	The administrator of that system for details.
	Content preview:  Next is the rwsem. static inline void read_lock(unsigned long
	*rw) { asm volatile("lock xorl ebp, %0\n" : "+m" (*rw) : : "memory", "cc");
	} /* BUG! There should be the write queue. It the one per rwlock */ static
	inline void read_unlock(unsigned long *rw) { asm volatile("lock xorl ebp,
	%0\n\t" "jne 1f\n\t" "call wakeup_writers\n" "1:" : "+m" (*rw) : : "memory",
	"cc"); } /* It is need another writelocking for interrupt context. This should
	call yield to wait for the read completion */ static inline void write_lock(unsigned
	long *rw) { asm volatile("1:" "lock incl %0\n\t" "lock decl %0\n\t" "je 2f\n\t"
	"call yield\n\t" "jmp 1b\n" "2:" : "+m" (*rw) : : "memory", "cc"); } /* This
	empty so reliable writelocking is impossible. The cure is fault tolerance
	*/ static inline void write_unlock(unsigned long *rw) { } [...] 
	Content analysis details:   (-1.7 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.7 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next is the rwsem.

static inline void read_lock(unsigned long *rw)
{
  asm volatile("lock xorl ebp, %0\n"
    : "+m" (*rw)
    :
    : "memory", "cc");
}
/* BUG! There should be the write queue. It the one per rwlock */
static inline void read_unlock(unsigned long *rw)
{
  asm volatile("lock xorl ebp, %0\n\t"
    "jne 1f\n\t"
    "call wakeup_writers\n"
    "1:"
    : "+m" (*rw)
    :
    : "memory", "cc");
}
/* It is need another writelocking for interrupt context.
   This should call yield to wait for the read completion */
static inline void write_lock(unsigned long *rw)
{
  asm volatile("1:"
    "lock incl %0\n\t"
    "lock decl %0\n\t"
    "je 2f\n\t"
    "call yield\n\t"
    "jmp 1b\n"
    "2:"
    : "+m" (*rw)
    :
    : "memory", "cc");
}
/* This empty so reliable writelocking is impossible.
   The cure is fault tolerance */
static inline void write_unlock(unsigned long *rw)
{
}

