Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYGAJVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYGAJVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYGAJVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:21:39 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39551 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbYGAJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:21:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.002784342@theryb.frec.bull.fr>
	<485F04E1.70204@gmail.com> <m1y74svtff.fsf@frodo.ebiederm.org>
	<486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org>
	<4869D314.5030403@gmail.com>
Date: Tue, 01 Jul 2008 02:20:20 -0700
In-Reply-To: <4869D314.5030403@gmail.com> (Tejun Heo's message of "Tue, 01 Jul
	2008 15:47:48 +0900")
Message-ID: <m1ej6enep7.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <htejun@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0565]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 06/11] sysfs: Implement sysfs tagged directory support.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Hello, Eric.
>
> Eric W. Biederman wrote:
>>> It's still dynamic from sysfs's POV and I think that will make
>>> maintenance more difficult.
>> 
>> Potentially.  I have no problem make it clear that things are more static.
>
> Great. :-)
>

> Having enumed tag types limits that a sb can have map to only one tag
> but it doesn't really prevent multiple possibly visible entries which is
> the real unnecessary degrees of freedom.  That said, I don't really
> think it's an issue.

Having a single tag type per directory and thus a single tag visible per
directory does prevent multiple possible visible entries.

That is we can check when we add the sd if there will be a conflict in
the directory.

>> The number of tag types will be low as it is the number of subsystems
>> that use the feature.  Simple enough that I expect statically allocating
>> the tag types in an enumeration is a safe and sane way to operate.
>> i.e.
>> 
>> enum sysfs_tag_types {
>> 	SYSFS_TAG_NETNS,
>> 	SYSFS_TAG_USERNS,
>>         SYSFS_TAG_MAX
>> };
>
> I still would prefer something which is more generic.  The abstraction
> is clearer too.  A sb shows untagged and a set of tags.  A sd can either
> be untagged or tagged (a single tag).

That is the abstraction now.

The only difference is how we represent the set of tags.
I use and array of the valid tags.
You use a bitmap.

And array allows the lookup of the tag I am looking for before
I search for the sd.  An bitmap requires me to compare each entry.

For me that is a deal breaker.  Currently in certain pathological
cases we have scaling issues with sysctl and sysfs that we can
have enormous directories that start running slowly.  To fix
lookup performance requires that we know the full name before
we do the directory search which is the name string and the
tag.

So I having a type of tag as being of fundamental importance in
the interface now so we don't need to refactor all of the users
later.  In addition to the fact that we need the type to know
how to set the tags when mounting a superblock and when
given a new kobject to create an sd for.

We could make the types dynamic rather then a static enumeration but
that seems needless complexity for now.

> Using ida (or idr if a pointer for private data is necessary) is really
> easy.  It'll probably take a few tens of lines of code.  That said, I
> don't think I have enough rationale to nack what you described.  So, as
> long as the tags are made static, I won't object.

Sounds good.  The only justification I can think of for ida tags is that
they are smaller, and so can keep the sysfs_dirents smaller.    Which
occasionally is a significant concern.  Still that should be an optimization
that we can apply later, as it is not a structural difference in the code.

Just to confirm.  Do you the two operations:
  mount_tag - called only when the sb is mounted 
  kobject_tag - called when we create new sd or rename an sd

Cause you to view an the tags as dynamic?

Eric
