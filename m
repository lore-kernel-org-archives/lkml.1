Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYKLFEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYKLFEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYKLFD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:03:27 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:57539 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYKLFDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:03:25 -0500
Date: Tue, 11 Nov 2008 23:03:19 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v9][PATCH 00/13] Kernel based checkpoint/restart
Message-ID: <20081112050319.GA3687@us.ibm.com>
References: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> Checkpoint-restart (c/r): v9 adds support for multiple processes.
> (rebase to v2.6.28-rc3).
> 
> We'd like to see these make their way into -mm. All comments have
> been addressed in this version. Please pull at least the first 11
> patches, as they are similar to before.

With the trivial fix to patch 5 I sent earlier, I've been running the
following e2loop.sh for a few hours with no problems (the counter is at
2412).  Also did 500 concurrent checkpoints of the same process.

Oren, can you re-post an updated patch 5?

Andrew, would you mind (once Oren reposts patch 5) giving the
first 11 patches a chance in -mm?

thanks,
-serge

===============
e2loop.sh:
===============
cnt=1
/usr/src/ns_exec -m /root/e2 &
while [ 1 ]; do
        /usr/src/cr `pidof e2` o.$cnt
        kill -9 `pidof e2`
        echo 5 > /root/e2out
        cntin=`cat /root/e2out`
        echo "i reset e2out to $cntin"
        #/usr/src/rstr < /root/o.$cnt &
        /usr/src/ns_exec -m /usr/src/rstr /root/o.$cnt &
        cnt=$((cnt+1))
        sleep 10
        cntin=`cat /root/e2out`
        echo "cnt is $cnt, e2out has $cntin"
done

===============
e2.c:
===============
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
	int cnt=0;
	FILE *f;
	char fnam[20];

	close(0); close(1); close(2); close(3);
	f = fopen("e2out", "r");
	if (!f)
		cnt = 1;
	else {
		fscanf(f, "%d", &cnt);
		fclose(f);
	}
	for (;;) {
		sleep(5);
		f = fopen("e2out", "w");
		if (!f)
			return 1;
		fprintf(f, "%d", ++cnt);
		fclose(f);
	}
	return 0;
}

