Return-Path: <linux-kernel-owner+w=401wt.eu-S1765221AbZEAUJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765221AbZEAUJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbZEAUJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:09:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:6724 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZEAUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JJVRr8WS5aJnzZvDs6pQQv1WfP2Xx03EXHZRQWOR+y99UnbJsJIJbn1wlt6YU/rGpm
         GdFwtD0wwqQmKOYgKtT8/ywbkTFPBbZyJbP7nICwfQ2gX1P4734PcGdPMCtd2YfaNa5H
         v+nvuavHvnWevwM9DW5Vmb1NBVBrinIupbRgo=
Date: Sat, 2 May 2009 00:09:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH -tip] x86: uv - prevent NULL dereference in
	uv_system_init
Message-ID: <20090501200937.GD4633@lenovo>
References: <20090501195638.GC4633@lenovo> <20090501200331.GA2645@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501200331.GA2645@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, May 01, 2009 at 10:03:31PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| 
| > We may reach NULL dereference oops if kmalloc failed.
| > Lets do panic better with sensible message.
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > ---
| > 
| > Actually there is a dubious place as well at early_get_nodeid.
| > Is there a guarantee that we _never_ fail in early_ioremap?
| > 
| >  arch/x86/kernel/apic/x2apic_uv_x.c |    9 +++++++++
| >  1 file changed, 9 insertions(+)
| > 
| > Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
| > =====================================================================
| > --- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
| > +++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
| > @@ -584,15 +584,21 @@ void __init uv_system_init(void)
| >  
| >  	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
| >  	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
| > +	if (!uv_blade_info)
| > +		goto err_nomem;
| 
| hm, i think a BUG_ON() might be shorter and more appropriate here. 
| We really shouldnt be running out of memory during system init.
| 
| 	Ingo
| 

Yeah, indeed! I was thinking of __GPF_NOFAIL here as well with
message on top like pr_debug("UV: allocating memory\n") or something
like that. It would make it even cleaner I guess. Hmm?

	-- Cyrill
