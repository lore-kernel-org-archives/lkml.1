Return-Path: <linux-kernel-owner+w=401wt.eu-S1762470AbYD2Ulh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762470AbYD2Ulh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYD2Ul2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:41:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbYD2Ul1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:41:27 -0400
Date: Tue, 29 Apr 2008 13:35:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: hpa@zytor.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH] x86: GEODE: cache results from geode_has_vsa2() and
 uninline
Message-Id: <20080429133512.fcd8f8dd.akpm@linux-foundation.org>
In-Reply-To: <20080429013213.4084e892@ephemeral>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419031024.GC3503@nineveh.local>
	<20080418202925.b18452c5.akpm@linux-foundation.org>
	<20080419092544.378664a8@ephemeral>
	<20080419133909.5aa6b63e@ephemeral>
	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	<480C0582.9010509@firmworks.com>
	<86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
	<480C1286.3040307@firmworks.com>
	<20080421102417.6de71391@ephemeral>
	<1208793253.9212.507.camel@pmac.infradead.org>
	<20080421130320.38b5f505@ephemeral>
	<1208805491.9212.520.camel@pmac.infradead.org>
	<20080421154618.2ed4978f@ephemeral>
	<1208809517.9212.537.camel@pmac.infradead.org>
	<20080421170230.2db18632@ephemeral>
	<20080428200651.169f1db1.akpm@linux-foundation.org>
	<20080429013213.4084e892@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 01:32:13 -0400
Andres Salomon <dilinger@queued.net> wrote:

> On Mon, 28 Apr 2008 20:06:51 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 21 Apr 2008 17:02:30 -0400 Andres Salomon <dilinger@queued.net> wrote:
> > 
> > > +	if (!is_geode() || geode_has_vsa2())
> > 
> > geode_has_vsa2() is a fairly expensive-looking function and afacit only
> > needs to be evaluated once per boot.  Perhaps we should cache it somewhere?
> > 
> 
> How about this?
> 

Looks sane.  Although one wonders if it should be cached as one of the
standard x86 feature bit thingies which show up in /proc/cpuinfo's 'flags'
field.

> +static int has_vsa2 = -1;
> +
> +int geode_has_vsa2(void)
> +{
> +	if (has_vsa2 == -1) {
> +		/*
> +		 * The VSA has virtual registers that we can query for a
> +		 * signature.
> +		 */
> +		outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
> +		outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
> +
> +		has_vsa2 = (inw(VSA_VRC_DATA) == VSA_SIG);
> +	}
> +
> +	return has_vsa2;
> +}
> +EXPORT_SYMBOL_GPL(geode_has_vsa2);

nit:

--- a/arch/x86/kernel/geode_32.c
+++ a/arch/x86/kernel/geode_32.c
@@ -161,10 +161,10 @@ void geode_gpio_setup_event(unsigned int
 }
 EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
 
-static int has_vsa2 = -1;
-
 int geode_has_vsa2(void)
 {
+	static int has_vsa2 = -1;
+
 	if (has_vsa2 == -1) {
 		/*
 		 * The VSA has virtual registers that we can query for a

