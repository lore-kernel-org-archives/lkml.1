Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbYG3PIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbYG3PIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761619AbYG3PI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:08:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:53620 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761452AbYG3PI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IrigZvKzyWGRSB+5mJR9w6MUp9UZdsIKat0UxsYHgRvIPJ+kGktdHZ3MnvquUad166
         isgwJnq6O3CuS1ohSkyM20AleNMEAG2Zy43vgqQG48q205d0BMvQ7JA136FcrSaulctu
         edeDKYA1XfWIxgPiPOk+8tS2uCCdb8XAqRqow=
Message-ID: <9e4733910807300808s3ac0a383g30fd437de861554a@mail.gmail.com>
Date: Wed, 30 Jul 2008 11:08:25 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Adrian Bunk" <bunk@kernel.org>
Subject: Re: 463 kernel developers missing!
Cc: "Rene Herman" <rene.herman@keyaccess.nl>,
       "Paul Mundt" <lethal@linux-sh.org>, "James Morris" <jmorris@namei.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Dave Jones" <davej@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       "Simon Arlott" <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4890284E.3050806@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	 <20080728141414.d7e5def2.randy.dunlap@oracle.com>
	 <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au>
	 <20080728234131.GD28055@linux-sh.org>
	 <9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com>
	 <488E644D.7000507@keyaccess.nl>
	 <9e4733910807281750p52cf150lacd0e237732046e7@mail.gmail.com>
	 <488EF377.5080603@keyaccess.nl>
	 <20080730072448.GB1564@cs181140183.pp.htv.fi>
	 <4890284E.3050806@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/08, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Adrian Bunk wrote:
>  > Whether Jon's patch is a good idea one might discuss,
>
>
> There isn't a lot to discuss.  From a purely technical standpoint,
>  duplicating SCM metadata into a source file and aiming to be
>  comprehensive and up to date is naive at best.

I noticed that the log was full of errors and thought that it might be
nice to have a mechanism to correct them. Since the log is immutable,
error correction needs to be external. It is a different discussion as
to whether we should try and fix the errors in the log.

Assuming that we wanted the data clean I came up with this solution.
Maybe there is a better way.

Kernel log is immutable.
Kernel log contains about 1,000 errors of various classes.
.mailmap file format was preexisting, it maps email addresses to
people's names. If can be used to map the other direction, but none of
the kernel tools use it that way.

I observed that the unique key in the log is the email address, but
many of those email keys have errors in them, The data item we are
actually interested in is the developer's name.

I then generated a .mailmap file containing all of the unique email
addresses in the log and a guess from the log as to which developer
was associated with the email.

I then used various tools and hand editing to correct the ~1,000
errors and assign the correct developer name to the email in the log.
Correcting all these errors was a lot of work.It exposed the fact that
tools in the maintainer's change may be the largest source of errors.
Of course the file can be patched as more errors are found.

This new mailmap file now has two types of entries, ones fixing errors
and ones that are just copies of the data from the log.

I chose to leave both types of records in the file to make maintenance
easier. The complete set of email keys from the log is in the mailmap
file. To do maintenance, regenerate the email keys from the log and
diff them against mailmap. Now you only have to inspect the diff for
errors. After the diff is clean, add the new entires to the mailmap.

If you remove entries from the mailmap file they will get flagged in
every maintenance sweep and need to be removed again. Of course this
will lead you to build a list of people who don't want to be in the
list.

The mailmap file is sorted by name instead of email even though it is
used to convert email to name. This makes it easy for humans to edit
when their name changes (like getting married). Find all of your
aliases and change them to reflect your new name. Output from all of
the tools using mailmap will be updated.

I see now that editing the name provides a mechanism for removing
people from the file, their names can be edited to 'anonymous' . The
email address can't be removed since they are keys and have to match
the immutable set in the log. People may not be happy when tools
report that the developer of the patch that is causing them problem is
'anonymous'.

A simplistic validation check would be for checkpatch to look up each
email address in a new patch and print a warning if the address was
not in mailmap. That would be enough to stop many of the common typo
errors.

Assuming we want the log data clean, what's a better solution?


>
>  > but as soon as someone puts an email address into a kernel commit
>  > Google will anyway find it:
>
>
> This doesn't justify what Jon did though.
>
>  Jon created a new database out of formerly disparate datasets, even
>  though we didn't provide him these datasets for this purpose.  The fact
>  that the means to create this database are rather trivial and cheap do
>  not mean that we implicitly agreed to what he did or that it wouldn't
>  matter whether we agree to it or not.
>
>  Jon even suggested that his database is then used to combine with
>  further databases (bugzilla accounts, mailinglist archives).  Again, the
>  fact that something like this is possible without great difficulties
>  doesn't make it right.
>
> --
>  Stefan Richter
>  -=====-==--- -=== ====-
>  http://arcgraph.de/sr/
>


-- 
Jon Smirl
jonsmirl@gmail.com
