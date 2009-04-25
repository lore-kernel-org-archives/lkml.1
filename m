Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZDYTIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZDYTIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 15:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZDYTIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 15:08:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47434 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZDYTIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 15:08:22 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, npiggin@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090425012020.457460929@suse.de>
	<20090425041829.GX8633@ZenIV.linux.org.uk>
	<20090425080143.GA29033@infradead.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 25 Apr 2009 12:08:16 -0700
In-Reply-To: <20090425080143.GA29033@infradead.org> (Christoph Hellwig's message of "Sat\, 25 Apr 2009 04\:01\:43 -0400")
Message-ID: <m1tz4ctuu7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: hch@infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, npiggin@suse.de, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christoph Hellwig <hch@infradead.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0061]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [patch 00/27] [rfc] vfs scalability patchset
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Sat, Apr 25, 2009 at 05:18:29AM +0100, Al Viro wrote:
>> However, files_lock part 2 looks very dubious - if nothing else, I would
>> expect that you'll get *more* cross-CPU traffic that way, since the CPU
>> where final fput() runs will correlate only weakly (if at all) with one
>> where open() had been done.  So you are getting more cachelines bouncing.
>> I want to see the numbers for this one, and on different kinds of loads,
>> but as it is I've very sceptical.  BTW, could you try to collect stats
>> along the lines of "CPU #i has done N_{i,j} removals from sb list for
>> files that had been in list #j"?
>> 
>> Splitting files_lock on per-sb basis might be an interesting variant, too.
>
> We should just kill files_lock and s_files completely.  The remaining
> user are may remount r/o checks, and with counters in place not only on
> the vfsmount but also on the superblock we can kill fs_may_remount_ro in
> it's current form.  

Can we?  My first glance at that code I asked myself if we could examine
i_writecount, instead of going to the file. My impression was that we
were deliberately only counting persistent write references from files
instead of transient write references.  As only the persistent write
references matter.  Transient write references can at least in theory
be flushed as the filesystem is remounting read-only.

Eric
