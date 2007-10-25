Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXJYNlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXJYNlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 09:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbXJYNl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 09:41:28 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:42740 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbXJYNl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 09:41:27 -0400
Date: Thu, 25 Oct 2007 16:41:24 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Subject: x86: randomize brk() and RLIMIT_DATA
Message-ID: <20071025134124.wc44gdud7ixghfxv@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jiri Kosina <jkosina@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h65omuuzr3mk4f62"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-10-15)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--h65omuuzr3mk4f62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Would be neat if randomized brk and setrlimit(RLIMIT_DATA, ...)
worked in a predictable way:

$ gcc brk.c -fPIC -pie -m64;./a.out;./a.out;./a.out
sbrk=0x7f721b815000 main=0x7f721af04860
sbrk succeeded (brk=0x7f721b909240)
sbrk=0x7fc3d77e2000 main=0x7fc3d66fa860
sbrk failed: Cannot allocate memory (brk=0x7fc3d77e2000)
sbrk=0x7f05b0615000 main=0x7f05af76b860
sbrk failed: Cannot allocate memory (brk=0x7f05b0615000)

-- 
Do what you love because life is too short for anything else.


--h65omuuzr3mk4f62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="brk.c"

#include <stdio.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <errno.h>
#include <string.h>

int main(void)
{
	void *p;
	const struct rlimit rlim_data = {
		.rlim_cur = 10 << 20,
		.rlim_max = RLIM_INFINITY
	};
	int saved_errno;

	p = sbrk(0);
	fprintf(stderr, "sbrk=%p main=%p\n", p, &main);
	if (setrlimit(RLIMIT_DATA, &rlim_data) == -1) {
		fprintf(stderr, "setrlimit failed: %s\n", strerror(errno));
		return 1;
	}
	if (sbrk(1 << 20) == (void*)-1) {
		saved_errno = errno;
		fprintf(stderr, "sbrk failed: %s (brk=%p)\n",
			strerror(saved_errno), sbrk(0));
		return 1;
	} else {
		fprintf(stderr, "sbrk succeeded (brk=%p)\n", sbrk(0));
		return 0;
	}
}


--h65omuuzr3mk4f62--
