Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbZAGU2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbZAGU2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760927AbZAGU1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:27:48 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:62417 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbZAGU1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:27:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Wumcn9SZU+l3MKEOidscXBG1P5xzO9f6OIffDcFv3wPq36NFN8eFll8TMfGFwbPqYl
         fKab7Mt0UdZmAR4VEJAoSj+/48BwsGGByVc+o0/28TXkP6sIDOrGYlu8U7wZXpeolefk
         d3g36U/w7AWdulBXhI7q36Xn/w7cZl3c2IMWU=
Message-ID: <86802c440901071227n2d110757ye1bd12e689502ebc@mail.gmail.com>
Date: Wed, 7 Jan 2009 12:27:46 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/5] cpumask: update irq_desc to use cpumask_var_t
Cc: "Ingo Molnar" <mingo@redhat.com>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Jack Steiner" <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, "Chris Wright" <chrisw@sous-sol.org>,
       "Jeremy Fitzhardinge" <jeremy@xensource.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com
In-Reply-To: <20090107195832.465094000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>
	 <20090107195832.465094000@polaris-admin.engr.sgi.com>
X-Google-Sender-Auth: 675f7ae7630bd36a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 11:58 AM, Mike Travis <travis@sgi.com> wrote:
| --- linux-2.6-for-ingo.orig/kernel/irq/numa_migrate.c
| +++ linux-2.6-for-ingo/kernel/irq/numa_migrate.c
| @@ -46,6 +46,7 @@ static void init_copy_one_irq_desc(int i
| 	desc->cpu = cpu;
| 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
| 	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
|+	init_copy_desc_masks(old_desc, desc);
| 	arch_init_copy_chip_data(old_desc, desc, cpu);
| }
|
|@@ -76,11 +77,20 @@ static struct irq_desc *__real_move_irq_
| 	node = cpu_to_node(cpu);
| 	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
| 	if (!desc) {
|-		printk(KERN_ERR "irq %d: can not get new irq_desc for migration.\n", irq);
|+		printk(KERN_ERR "irq %d: can not get new irq_desc "
|+				"for migration.\n", irq);
| 		/* still use old one */
| 		desc = old_desc;
| 		goto out_unlock;
| 	}
|+	if (!init_alloc_desc_masks(desc, node, false)) {
|+		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
|+				"for migration.\n", irq);
|+		/* still use old one */
|+		kfree(desc);
|+		desc = old_desc;
|+		goto out_unlock;
|+	}
| 	init_copy_one_irq_desc(irq, old_desc, desc, cpu);

desc new mask_var (allocated) aka the pointer is overwritten here...
you may need to calling move init_alloc_desc_masks() into
init_copy_one_irq_desc()

| 	irq_desc_ptrs[irq] = desc;

YH
