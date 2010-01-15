Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab0AOTEt (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627Ab0AOTEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:04:48 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:53556 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752910Ab0AOTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:04:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=H2qxSDhrVY5hNU8eVyO7g1SAGczYgCvI4TSUxKfMV1P2iG1LwmtVUzEoydFy3xW0kCyuZSuJnzbPfhR4ZksmZfsMZrxE/3QgFEG9eSYd/Y8WM4j7GcK7Z6gF/PKdQYHr;
Date: Fri, 15 Jan 2010 11:04:48 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 07/14] pci: don't shrink bridge resources
Message-ID: <20100115110448.379959ad@jbarnes-piketon>
In-Reply-To: <1261522954-12591-8-git-send-email-yinghai@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
	<1261522954-12591-8-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 15:02:27 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> when we are clearing leaf bridge resource and try to get big one, we
> could shrink the bridge if there is no resource under it.
> 
> let check with old resource size and make sure we are trying to get
> big one.
> 
> -v2: keep disable window print out, still could happen on non pci
> hotplug system
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 9bb4435..d53b42e 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -387,7 +387,7 @@ static void pbus_size_io(struct pci_bus *bus,
> resource_size_t min_size) {
>  	struct pci_dev *dev;
>  	struct resource *b_res = find_free_bus_resource(bus,
> IORESOURCE_IO);
> -	unsigned long size = 0, size1 = 0;
> +	unsigned long size = 0, size1 = 0, old_size;
>  
>  	if (!b_res)
>   		return;
> @@ -412,12 +412,17 @@ static void pbus_size_io(struct pci_bus *bus,
> resource_size_t min_size) }
>  	if (size < min_size)
>  		size = min_size;
> +	old_size = resource_size(b_res);
> +	if (old_size == 1)
> +		old_size = 0;

Do we even need these == 1 checks?  If old_size really was 1, it means
we had a very small decode range.  Might make more sense to do...

>  /* To be fixed in 2.5: we should have sort of HAVE_ISA
>     flag in the struct pci_bus. */
>  #if defined(CONFIG_ISA) || defined(CONFIG_EISA)
>  	size = (size & 0xff) + ((size & ~0xffUL) << 2);
>  #endif
>  	size = ALIGN(size + size1, 4096);
> +	if (size < old_size)
> +		size = old_size;

if (size && size < old_size)

here instead?  Just a nit because the if (old_size == 1) seemed a bit
magical at first.  Same thing applies later on.

-- 
Jesse Barnes, Intel Open Source Technology Center
