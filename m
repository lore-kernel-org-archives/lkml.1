Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbZFISjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbZFISjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZFISjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:39:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46069 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbZFISjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:39:08 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1oct739xu.fsf@fess.ebiederm.org>
	<1243893048-17031-3-git-send-email-ebiederm@xmission.com>
	<20090602070642.GD31556@wotan.suse.de>
	<m1ab4m5vbs.fsf@fess.ebiederm.org>
	<20090609103832.GI14820@wotan.suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 09 Jun 2009 11:38:59 -0700
In-Reply-To: <20090609103832.GI14820@wotan.suse.de> (Nick Piggin's message of "Tue\, 9 Jun 2009 12\:38\:32 +0200")
Message-ID: <m1hbypmev0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: npiggin@suse.de, ebiederm@aristanetworks.com, hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Nick Piggin <npiggin@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 03/23] vfs: Generalize the file_list
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> On Fri, Jun 05, 2009 at 12:33:59PM -0700, Eric W. Biederman wrote:
>> Nick Piggin <npiggin@suse.de> writes:
>> 
>> >> +static inline void file_list_unlock(struct file_list *files)
>> >> +{
>> >> +	spin_unlock(&files->lock);
>> >> +}
>> >
>> > I don't really like this. It's just a list head. Get rid of
>> > all these wrappers and crap I'd say. In fact, starting with my
>> > patch to unexport files_lock and remove these wrappers would
>> > be reasonable, wouldn't it?
>> 
>> I don't really mind killing the wrappers.
>> 
>> I do mind your patch because it makes the list going through
>> the tty's something very different.  In my view of the world
>> that is the only use case is what I'm working to move up more
>> into the vfs layer.  So orphaning it seems wrong.
>
> My patch doesn't orphan it, it just makes the locking more
> explicit and that's all so it should be easier to work with.
> I just mean start with my patch and you could change things
> as needed.

As I recall you weren't using the files_lock for the tty layer.  I
seem to recall you were still walking through the same list head on
struct file.

Regardless it sure felt like pushing the tty usage out into
some weird special case.  My goal is to make it reasonable for
more character drivers to use the list so it isn't an especially
comfortable starting place for me.

>> > Increasing the size of the struct inode by 24 bytes hurts.
>> > Even when you decrapify it and can reuse i_lock or something,
>> > then it is still 16 bytes on 64-bit.
>> 
>> We can get it even smaller if we make it an hlist.  A hlist_head is
>> only a single pointer.  This size growth appears to be one of the
>> biggest weakness of the code.
>
> 8 bytes would be a lot better than 24.

Definitely.

>> > I haven't looked through all the patches... but this is to
>> > speed up a slowpath operation, isn't it? Or does revoke
>> > need to be especially performant?
>> 
>> This was more about simplicity rather than performance.  The
>> performance gain is using a per inode lock instead of a global lock.
>> Which keeps cache lines from bouncing.
>
> Yes but we already have such a global lock which has been
> OK until now. Granted that some users are running into these
> locks, but fine graining them can be considered independently
> I think. So using per-sb lists of files and not bloating
> struct inode any more could be a less controversial step
> for you.

I will take a look.  Certainly doing the work in a couple
of patches seems reasonable.  If I can move all of the list
maintenance out of the tty layer.  That looks to be the ideal
case.

Eric
