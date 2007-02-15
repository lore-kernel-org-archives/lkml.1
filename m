Return-Path: <linux-kernel-owner+w=401wt.eu-S1030436AbXBOSOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030436AbXBOSOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030437AbXBOSOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:14:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:49243 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030436AbXBOSOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:14:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Maynard Johnson <maynardj@us.ibm.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Date: Thu, 15 Feb 2007 19:13:52 +0100
User-Agent: KMail/1.9.5
Cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Carl Love <cel@us.ibm.com>
References: <1171497138.23691.8.camel@dyn9047021078.beaverton.ibm.com> <200702151537.51202.arnd@arndb.de> <45D4870C.9070908@us.ibm.com>
In-Reply-To: <45D4870C.9070908@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702151913.53594.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/0GuHsChPq+yxEFZ94zOYkiTUhapaY3/CO+MMjvee8b7Oa9HCZCrxVxjQ88biHTI+2YM9yG45jBBrWc9SX5ObRZ0YqaCo1byLMNPqSvEKxmA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 17:15, Maynard Johnson wrote:
> >>+void spu_set_profile_private(struct spu_context * ctx, void * profile_info,
> >>+                          struct kref * prof_info_kref,
> >>+                          void (* prof_info_release) (struct kref * kref))
> >>+{
> >>+     ctx->profile_private = profile_info;
> >>+     ctx->prof_priv_kref = prof_info_kref;
> >>+     ctx->prof_priv_release = prof_info_release;
> >>+}
> >>+EXPORT_SYMBOL_GPL(spu_set_profile_private);
> >>    
> >>
> >
> >I think you don't need the profile_private member here, if you just use
> >container_of with ctx->prof_priv_kref in all users.
> >  
> >
> Sorry, I don't follow. We want the profile_private to be stored in the 
> spu_context, don't we?  How else would I be able to do that?  And 
> besides, wouldn't container_of need the struct name of profile_private?  
> SPUFS doesn't have access to the type.

The idea was to have spu_get_profile_private return the kref pointer,
and then change the user of that to do

+       if (!spu_info[spu_num] && the_spu) {
+               spu_info[spu_num] = container_of(
+				spu_get_profile_private(the_spu->ctx),
+				struct cached_info, cache_kref);
+               if (spu_info[spu_num])
+                       kref_get(&spu_info[spu_num]->cache_ref);
