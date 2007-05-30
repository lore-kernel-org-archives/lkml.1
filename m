Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbXE3TOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbXE3TOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXE3TOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:14:39 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:22036 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXE3TOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M/V4rBaziY8gUCvL46JktK1QnnweK8syb0HirebFVjPOKcxnAqSMFsNwC5vgP4h2OdgLw2tqx1Png2+XnIsTVwZAnQNhUlFeYK+yLT8DCq6hgJQJ7qvUgPG9cYFltASLs5r8gU8zF1hnuz9HbavEUb/uaNhQd98CT28Z7/nuGAo=
Message-ID: <a781481a0705301214h3295315esa31c40933ae4a539@mail.gmail.com>
Date: Thu, 31 May 2007 00:44:30 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tilman Schmidt" <tilman@imap.cc>
Subject: Re: dealing with gcc 'comparison is always false' warnings
Cc: "Roland Dreier" <rdreier@cisco.com>, openib-general@openib.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <465DC9E9.3040904@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070530080518.GA29195@nostromo.devel.redhat.com>
	 <adazm3mqqh3.fsf@cisco.com>
	 <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
	 <465DC9E9.3040904@imap.cc>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/31/07, Tilman Schmidt <tilman@imap.cc> wrote:
> Am 30.05.2007 17:41 schrieb Satyam Sharma:
> > On 5/30/07, Roland Dreier <rdreier@cisco.com> wrote:
> >> thanks... I'm wondering if there's a consensus among kernel hackers
> >> about changes like:
> >>
> >>  > -    if (hdr.cmd < 0 || hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
> >>  > +    if (hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
> >>  >              return -EINVAL;
> >>
> >> I understand that new gcc sees that hdr.cmd is unsigned and hence
> >> can't be < 0, and generates a warning for that, and having a build
> >> cluttered with warnings hides bugs and so on.  However the code here
> >> looks quite sensible to me -- otherwise we end up with missing range
> >> checking if hdr.cmd ever changes to a signed type.  This seems like a
> >> good way to introduce bugs: delete valid range checking code to shut
> >> up a silly gcc warning, and then change the type of a variable.
> >
> > You're *absolutely* correct about the issue that these "fixes" that remove
> > such conditions end up remove range-checking making the code more
> > flakey / less readable.
>
> I disagree. Changing the type of a variable is a significant
> modification. If someone does that, he or she *must* check every
> use of that variable, at which point he or she will also modify
> any range checks accordingly. Having checks that don't fit with
> the previous type *distracts* from that job. "Oh, did I modify
> that part already? Guess I can skip checking the rest of that
> function then." Oops.

I did not suggest the change-variable-type-from-unsigned-to-signed
thing as a "general" solution to such cases! ... in fact what I said
was that such cases do _not_ have a general solution at all, and
that shutting gcc up might not be a good idea, because a lot of
times such warnings do un-hide bugs. [ BTW when I gave the
change-type-from-unsigned-to-signed example, I had the size_t vs
ssize_t typo/bug in mind, for which changing the type is the proper
fix; and note that similar bugs can occur for non-size_t cases too. ]

> Nor is readability a suitable argument. Checking if hdr.cmd is
> less than zero gives the misleading impression that it *could*
> be less than zero, thus *impairing* readability.

Hmmm, but I tend to agree with the sentiment expressed in:
http://lkml.org/lkml/2006/11/28/206

Satyam
