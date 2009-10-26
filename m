Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZJZRTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZJZRTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZJZRTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:19:48 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:49531 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752698AbZJZRTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:19:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jQXhXVg9Uvsz+GDbBzMFnWQblilUgctgPB837Ae04x7gKSscRjpYXciLfpoNvmyKPhmAcPDVOz1rnZw6Mpj9CwPf0mXyn6o5o12OIe4r1IjSXmjJruaE7jvXsOQCnupJ;
Date: Mon, 26 Oct 2009 10:19:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pci: only release that resource index is less than 3
Message-ID: <20091026101942.578f41b2@jbarnes-g45>
In-Reply-To: <200910261032.58231.bjorn.helgaas@hp.com>
References: <4AE2C827.8040905@kernel.org>
	<200910261032.58231.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 10:32:57 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Saturday 24 October 2009 03:25:59 am Yinghai Lu wrote:
> > after
> > 
> > | commit 308cf8e13f42f476dfd6552aeff58fdc0788e566
> > |
> > |    PCI: get larger bridge ranges when space is available
> > 
> > found one of resource of peer root bus (0x00) get released from root
> > resource. later one hotplug device can not get big range anymore.
> > other peer root buses is ok.
> > 
> > it turns out it is from transparent path.
> > 
> > those resources will be used for pci bridge BAR updated.
> > so need to limit it to 3.
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > ---
> >  drivers/pci/setup-bus.c |    9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6/drivers/pci/setup-bus.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/setup-bus.c
> > +++ linux-2.6/drivers/pci/setup-bus.c
> > @@ -344,9 +344,14 @@ static struct resource *find_free_bus_re
> >  			 * if there is no child under that, we
> > should release
> >  			 * and use it. don't need to reset it,
> > pbus_size_* will
> >  			 * set it again
> > +			 * need to be less 3, otherwise can not
> > write it to
> > +			 * bridge, also need to avoid releasing it
> > from
> > +			 * transparent bus path
> >  			 */
> > -			if (!r->child && !release_resource(r))
> > -				return r;
> > +			if (i < 3 && !r->child) {
> > +				if (!release_resource(r))
> > +					return r;
> > +			}
> 
> I am bewildered.
> 
> 308cf8e13f42f added the release_resource() call here in
> find_free_bus_resource().  I don't understand why the release
> should be there in the first place -- it doesn't seem to
> logically fit there.  A "release" should be connected to an
> event, maybe a hot-remove or a move of a device from one place
> to another.  It shouldn't be something we do as a side-effect
> of searching for a free resource.
> 
> Now you're adding the magic number "3", which seems even less
> related to the job of "finding an available bus resource."  I'm
> guessing the "3" is related to PCI_BRIDGE_RESOURCES or something,
> but that should be made explicit, and I really don't think it
> belongs in this function.

I agree, the 3 is a bit of magic.  The free could probably be shuffled
around a bit too, though it really is related to finding bus
resources.  I was a bit ambivalent about putting it in
find_free_bus_resources but when I started a reply to Yinghai and
looked for a better place it made some sense to leave it as-is.

But if we're going to be adding more logic here, we should probably
figure out a better way of doing it, maybe by adding a new pass to do
the freeing?  I know we've avoided modifying bus resources too much in
the past, but I think that'll be harder and harder to avoid as Windows
moves to that model and platforms begin to expect it.

-- 
Jesse Barnes, Intel Open Source Technology Center
