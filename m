Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZLAAMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZLAAMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZLAAMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:12:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44958 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZLAAMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:12:46 -0500
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<m1pr7tmqb4.fsf@fess.ebiederm.org> <20091130213337.GA3468@kroah.com>
	<20091130215347.GA2750@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 30 Nov 2009 16:12:39 -0800
In-Reply-To: <20091130215347.GA2750@kroah.com> (Greg KH's message of "Mon\, 30 Nov 2009 13\:53\:47 -0800")
Message-ID: <m1y6lnlfgo.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 0/15] sysfs lazification final
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Mon, Nov 30, 2009 at 01:33:37PM -0800, Greg KH wrote:
>> On Sat, Nov 07, 2009 at 11:25:03PM -0800, Eric W. Biederman wrote:
>> > 
>> > The sysfs code updates the vfs caches immediately when the sysfs data
>> > structures change causing a lot of unnecessary complications.  The
>> > following patchset untangles that beast.  Allowing for simpler
>> > more straight forward code, the removal of a hack from the vfs
>> > to support sysfs, and human comprehensible locking on sysfs.
>> > 
>> > Most of these patches have already been reviewed and acked from the
>> > last time I had time to work on sysfs.
>> > 
>> > This acks have been folded in and the two small bugs found in the
>> > previous review have been fixed in the trailing patches (they are
>> > minor enough nits that even a bisect that happens to land in the
>> > middle should not see sysfs problems).
>> 
>> I've applied all of these to my tree now, and sorry, but something is
>> broken pretty badly.
>> 
>> When doing a simple 'ls /sys/class/input/' the process locks up.  This
>> means that X can't find any input devices, which makes for a bit of a
>> problem when wanting to use your mouse or keyboard :(
>> 
>> Attached is the state of my processes when this happens, if that helps
>> out any.
>> 
>> So I'm going to drop all of these from my tree again, as they are not
>> ready for merging at this point :(
>
> In looking at the stuck processes, it seems your last patch was the
> problem.  Removing that caused things to work again, so I've only
> dropped that one.
>
> Next time, please test your patches before submitting them :(

Weird I thought I had tested this.

That last patch to add locking that is only needed for vfs coherency
has certainly seen less testing than the others.

I also remember verify that nfs does the same thing, when in fact
nfs takes inode->i_lock not inode->i_mutex in the same situation.

generic_permission takes no locks so this is really about serializing
writes to the inode.  The vfs only takes inode->i_mutex, when calling
notify_change.

So it appears I have stepped into a murky corner of the vfs.  

I will take a look and do a bit more testing.   At the moment it looks
like a solution to serializing writes to the stat attributes on the inode is
going to be simply holding sysfs_mutex over inode_setattr in 
sysfs_setattr.  Assuming a solution is needed at all.

Eric
