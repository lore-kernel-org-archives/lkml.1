Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZDNI2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZDNI2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZDNI2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:28:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46023 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZDNI2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:28:06 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Hugh Dickins <hugh@veritas.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <m1skkf761y.fsf@fess.ebiederm.org> <49E4000E.10308@kernel.org>
	<m13acbbs5u.fsf@fess.ebiederm.org> <49E43F1D.3070400@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 14 Apr 2009 01:27:58 -0700
In-Reply-To: <49E43F1D.3070400@kernel.org> (Tejun Heo's message of "Tue\, 14 Apr 2009 16\:45\:33 +0900")
Message-ID: <m18wm38ws1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: tj@kernel.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, hugh@veritas.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC][PATCH 0/9] File descriptor hot-unplug support
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>> Do you know of a case where we actually have multiple tasks accessing
>> a file simultaneously?
>
> I don't have anything at hand but multithread/process server accepting
> on the same socket comes to mind.  I don't think it would be a very
> rare thing.  If you confine the scope to character devices or sysfs,
> it could be quite rare tho.

Yes.  I think I can safely exclude sockets, and not bother with
reference counting them.

The only strong evidence I have that multi-threading on a single file
descriptor is likely to be common is that we have pread and pwrite
syscalls.  At the same time the number of races we have in struct file
if it is accessed by multiple threads at the same time, suggests
that at least for cases where you have an offset it doesn't happen often.

I cringe when I see per cpu counters for something like files that we
are likely to have a lot of.  I keep imagining a quadratic explosion
in data size.  In practice we are likely to have a small cpu count <=
8-16 cpus so it is likely ok.  Especially if we are only allocating 8
bytes per cpu per file.  I guess in total that is at most 128K per file.
8bytes*16k cpus.  With the default system file-max on my systems 203871
to 705863, it looks like we would max out at between 1M and 5M per cpu.
Still a lot but survivable.

Somewhere it all falls down, but only if you max out a very rare
very large machine, and that seems to be case with just about everything.

Which all leads me to say that if we can avoid per cpu memory and not impact
performance I want to do that.

Eric
