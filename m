Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab0AOVb6 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407Ab0AOVb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:31:57 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:53769 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758404Ab0AOVb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:31:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KpAhgY7IB+tnt4ZeavGKvyuXgZmsbePpd8M8MLbvN6A+HDnJiK8vM3ZDt11y2WJXFPpZcXhNGbB345Ya+zCJWJjtD/7HVxDIb7fsyLAyeqSuEll4wpwxTQg4+IxgP7gP;
Date: Fri, 15 Jan 2010 13:31:55 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 07/14] pci: don't shrink bridge resources
Message-ID: <20100115133155.3bc1960c@jbarnes-piketon>
In-Reply-To: <4B50D98B.3000801@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
	<1261522954-12591-8-git-send-email-yinghai@kernel.org>
	<20100115110448.379959ad@jbarnes-piketon>
	<4B50D98B.3000801@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010 13:09:31 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On 01/15/2010 11:04 AM, Jesse Barnes wrote:
> > On Tue, 22 Dec 2009 15:02:27 -0800
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> when we are clearing leaf bridge resource and try to get big one,
> >> we could shrink the bridge if there is no resource under it.
> >>
> >> let check with old resource size and make sure we are trying to get
> >> big one.
> >>
> >> -v2: keep disable window print out, still could happen on non pci
> >> hotplug system
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> ---
> >>  drivers/pci/setup-bus.c |   14 ++++++++++++--
> >>  1 files changed, 12 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> >> index 9bb4435..d53b42e 100644
> >> --- a/drivers/pci/setup-bus.c
> >> +++ b/drivers/pci/setup-bus.c
> >> @@ -387,7 +387,7 @@ static void pbus_size_io(struct pci_bus *bus,
> >> resource_size_t min_size) {
> >>  	struct pci_dev *dev;
> >>  	struct resource *b_res = find_free_bus_resource(bus,
> >> IORESOURCE_IO);
> >> -	unsigned long size = 0, size1 = 0;
> >> +	unsigned long size = 0, size1 = 0, old_size;
> >>  
> >>  	if (!b_res)
> >>   		return;
> >> @@ -412,12 +412,17 @@ static void pbus_size_io(struct pci_bus *bus,
> >> resource_size_t min_size) }
> >>  	if (size < min_size)
> >>  		size = min_size;
> >> +	old_size = resource_size(b_res);
> >> +	if (old_size == 1)
> >> +		old_size = 0;
> > 
> > Do we even need these == 1 checks?  If old_size really was 1, it
> > means we had a very small decode range.  Might make more sense to
> > do...
> 
> when start=0 and end =0, will get old_size = 1

...
if (old_size == 1)
  old_size = 0
...
if (size < old_size)
  size = old_size
...


If old_size > 1 we'll make sure size doesn't decrease.

If old_size == 1, we'll never touch the changed size because size < 0
will never be true for size (unsigned).

However, if old_size == 1 and we left it at 1, we'd only set size =
old_size if size was 0, which is why I suggested the size check.

What am I missing?  When will size shrink?  I know it's just
nitpicking, I just want to make sure the code is clear, and that it's
obvious that we're preventing size from decreasing.

-- 
Jesse Barnes, Intel Open Source Technology Center
