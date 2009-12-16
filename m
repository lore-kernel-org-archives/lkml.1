Return-Path: <linux-kernel-owner+w=401wt.eu-S965224AbZLPXF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965224AbZLPXF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935312AbZLPXFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:05:24 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:58556 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935317AbZLPXFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:05:22 -0500
Date: Wed, 16 Dec 2009 21:05:14 -0200
From: cascardo@holoscopio.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
Message-ID: <20091216230514.GB7791@holoscopio.com>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
 <1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
 <1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
 <4AF8B4FF.9050405@zytor.com>
 <20091111153632.944a255c.akpm@linux-foundation.org>
 <20091215143446.8b6a7e57.akpm@linux-foundation.org>
 <20091215233738.26188500@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215233738.26188500@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:37:38PM +0000, Alan Cox wrote:
> > > I merged this patch, but made a note-to-self that there are remaining
> > > open issues..
> > 
> > And nothing else happened.  Can we revisit this please?
> 
> The last I saw was a request for an explanation of the users
> configuration and how he was getting so many misc devices. Its a bug in
> dlm if the dlm is doing that but I didn't see any follow up to the DLM
> folks on the subject from the reporter, so it stays NACKed and conflicts
> with the device registry.
> 

I don't recall an explanation fro my DLM configuration. Probably my
mistake, sorry.

However, I haven't hit any DLM problem because I am no DLM user. My
concern was that the current code has overlapping ranges for the dynamic
range of device numbers and the first static device numbers. They do not
conflict at first because the dynamic range grows downards, and I kept
that behaviour in the other patch.

When I realized this, I decided to check what code did use misc dynamic
minors. I've accounted about 40 users and one in special caught my
attention. That was DLM, because it could potentially create many
devices.

> We need to know from the DLM folks/Thaddeu what is actually going on with
> that system, especially as it seems to be producing multiple
> registrations of the same misc device name which is completely broken and
> should probably be made to error anyway.
> 
> Whatever is going on this is the wrong "fix". If DLM should only register
> it once (as seems the intent) then DLM needs fixing or the users config
> or both. If it can register many then DLM needs fixing to not eat misc
> devices.
> 

It will only create that many devices if we request it to do so. But
requesting it is simply a matter of doing an ioctl. I think going for a
dynamic major of its own would be a better solution for DLM in the long
term.

> <eviltwin>Possibly we need to make it BUG_ON() adding the same name twice, then
> perhaps we'd get more feedback</eviltwin>

That was an unrelated problem, that made me look at the misc code at
first. I was playing with registering and unregistering misc devices.
And, then, I've hit the bug: after registering two devices with the same
name and unregistering both of them afterwards, a minor number got
unavailable for any further registering. That was fixed in the first
patch in the series.

I think a BUG_ON at driver core is not that bad an idea at all. Let me
try it. This bug would be hit even with the misc fix applied, since misc
would still try to register the device, and, then (now with the patch)
release the allocated minor number, returning error to the registerer.

> 
> Alan

Regards,
Cascardo.
