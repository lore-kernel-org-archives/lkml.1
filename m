Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbZKLV2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbZKLV2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZKLV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:28:40 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3111 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbZKLV2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:28:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=J1FJuDZ24bzMSIaxavp16lG/88ls4Ovh2Rpp1zKC14Ee+nIJiKuvFV8XPo7KWOrEo
	M5iMRf/4VnI5VUQW7WGlQ==
Date: Thu, 12 Nov 2009 13:28:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ACPI: Limit the number of per cpu ACPI bootup
 messages
In-Reply-To: <4AFC7BCA.3070705@sgi.com>
Message-ID: <alpine.DEB.2.00.0911121324280.17797@chino.kir.corp.google.com>
References: <20091112171934.584037000@alcatraz.americas.sgi.com> <20091112171949.218777000@alcatraz.americas.sgi.com> <alpine.DEB.2.00.0911121259260.13943@chino.kir.corp.google.com> <4AFC7BCA.3070705@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Mike Travis wrote:

> > > --- linux.orig/drivers/acpi/tables.c
> > > +++ linux/drivers/acpi/tables.c
> > > @@ -66,11 +66,15 @@
> > >  		{
> > >  			struct acpi_madt_local_x2apic *p =
> > >  			    (struct acpi_madt_local_x2apic *)header;
> > > -			printk(KERN_INFO PREFIX
> > > -			       "X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
> > > -			       p->local_apic_id, p->uid,
> > > -			       (p->lapic_flags & ACPI_MADT_ENABLED) ?
> > > -			       "enabled" : "disabled");
> > > +			/*
> > > +			 * Per cpu tracing clogs console output when NR_CPUS
> > > +			 * is large.  Send only to kernel log buffer.
> > > +			 */
> > > +			printk(KERN_DEBUG PREFIX
> > > +				"X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
> > > +				p->local_apic_id, p->uid,
> > > +				(p->lapic_flags & ACPI_MADT_ENABLED) ?
> > > +					"enabled" : "disabled");
> > >  		}
> > >  		break;
> > >  
> > 
> > You can still use dev_dbg(PREFIX "...") here.
> 
> I thought dev_dbg needed the 'dev' structure and I wasn't sure how to get
> that...?
> 

Ah, ok, it needs to be pr_debug(PREFIX "...") then.

Any reason why the other printk's in acpi_table_print_madt_entry() weren't 
converted to use KERN_DEBUG?  It might make more sense to convert all 
those to use a new acpi=verbose flag.

I'm not sure if Ingo is the right person to go through for acpi patches, I 
think this should probably be submitted to Len Brown <lenb@kernel.org> and 
linux-acpi@vger.kernel.org instead.
