Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZDLUzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZDLUzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 16:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZDLUyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 16:54:54 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34118 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZDLUyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 16:54:52 -0400
To: Jamie Lokier <jamie@shareable.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <m1skkf761y.fsf@fess.ebiederm.org>
	<m1prfj5qxp.fsf@fess.ebiederm.org>
	<20090412185659.GE4394@shareable.org>
	<m11vrxprk6.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 12 Apr 2009 13:54:45 -0700
In-Reply-To: <m11vrxprk6.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Sun\, 12 Apr 2009 13\:04\:09 -0700")
Message-ID: <m1r5zxk2y2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jamie@shareable.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jamie Lokier <jamie@shareable.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC][PATCH 8/9] vfs: Implement generic revoked file operations
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Jamie Lokier <jamie@shareable.org> writes:
>
>>> revoked_file_ops return 0 from reads (aka EOF). Tell poll the file is
>>> always ready for I/O and return -EIO from all other operations.
>>
>> I think read should return -EIO too.  If a program is reading from a
>> /proc file (say), and the thing it's reading suddenly disappears, EOF
>> gives the false impression that it's read to the end of formatted data
>> from that file and it can process the data as if it's complete, which
>> is wrong.

I just thought about that some more and I am not convinced.

In general the current return values from proc after an I/O operation
are suspect.  seek returns -EINVAL instead of -EIO. poll returns
DEFAULT_POLLMASK (which doesn't set POLLERR).  So I am not convinced
that the existing proc return values on error are correct, and they
are recent additions so the historical precedent is not especially
large.

EOF does give the impression that you have read all of the data from
the /proc file, and that is in fact the case.  There is no more
data coming from that proc file.

That the data is stale is well know.

That the data is not atomic, anything that spans more than a single
read is not atomic.

So I don't see what returning EIO adds to the equation.  Perhaps
that your fragile user space string parser may break?

EOF gives a clear indication the application should stop reading
the data, because there is no more.

EIO only says that the was a problem.

I don't know of anything that depends on the rmmod behavior either
way.  But if we can get away with it I would like to use something
that is generally useful instead of something that only makes
sense in the context of proc.

Eric
