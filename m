Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZIRQXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZIRQXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbZIRQXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:23:32 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:43862 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbZIRQXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xNESe2ijQcQSOJ5Gmy3UaNzX6vFgJRPC2/Wu9P6/vEdvqXfQqtxMGCxecH+LMdbf33
         yqZMHkJry/FmbZj0lri5Swu76m2wktV5r+q6Le60hhipRodzPKc2zdI9eZsLzd86ZdDm
         c5yK/Nsjva+taXh7LzOeBADsrXBwJ68p5Bxfk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.00.0909180339200.6267@chino.kir.corp.google.com>
References: <200909100601.n8A61Eju002109@imap1.linux-foundation.org>
	 <38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com>
	 <alpine.DEB.1.00.0909142147220.30373@chino.kir.corp.google.com>
	 <38c3c4860909150320qc4a203eu7552294ef0aafd2c@mail.gmail.com>
	 <alpine.DEB.1.00.0909151535150.17284@chino.kir.corp.google.com>
	 <38c3c4860909180238x7c9f305dsbce1492e2018c5a5@mail.gmail.com>
	 <alpine.DEB.1.00.0909180245030.24690@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0909180339200.6267@chino.kir.corp.google.com>
Date: Fri, 18 Sep 2009 21:53:32 +0530
Message-ID: <38c3c4860909180923j2d65e1c8o95c2c93f2e169b4b@mail.gmail.com>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
From: Suresh Jayaram <sureshjayaram@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 4:11 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 18 Sep 2009, David Rientjes wrote:
>
>> This seems to be related to 2547089 "x86/PCI: initialize PCI bus node
>> numbers early" since cpumask_of_pcibus() on x86 doesn't check for -1
>> pcibus_to_node() like most other architectures.  It'll simply index into
>> cpumask_of_node for whatever the pci_sysdata's node is, and in this case
>> that's -1.
>>
>
> Suresh, could you give this patch a try?  It turns out that the
> mp_bus_to_node map simply leaves all busses that don't have memory
> affinity to -1, so cpu_online_mask is actually the appropriate cpumask to
> return and x86 doesn't catch this.
>

Yeah, I applied this patch and verified, it works fine. No oopses, no traces..
Feel free to add my

Tested-by: Suresh Jayaraman <sjayaraman@suse.de>


Thanks,

> x86: default pcibus cpumask to all cpus if it lacks affinity
>
> The early initialization of the pci bus to node mapping leaves all busses
> with a node id of -1 if it lacks memory affinity.  Thus, cpumask_of_pcibus
> must return all online cpus for such busses.
>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/x86/include/asm/pci.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> --- a/arch/x86/include/asm/pci.h
> +++ b/arch/x86/include/asm/pci.h
> @@ -143,7 +143,11 @@ static inline int __pcibus_to_node(const struct pci_bus *bus)
>  static inline const struct cpumask *
>  cpumask_of_pcibus(const struct pci_bus *bus)
>  {
> -       return cpumask_of_node(__pcibus_to_node(bus));
> +       int node;
> +
> +       node = __pcibus_to_node(bus);
> +       return (node == -1) ? cpu_online_mask :
> +                             cpumask_of_node(node);
>  }
>  #endif
>
>
