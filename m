Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYDWRfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYDWRfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYDWRfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:35:18 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:55790 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYDWRfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BFsEBUIkBUKHXNdIgDuOEVdd682KLKh3RrNsYvmYZTilIGGWoropbFOL79Q84Rxrh4HdtUcw2I3WC3+ZODUFmOu7tfJm/9JAQbomGCw927m9WyOsI0ldIVfJRL9d2auobpTH6SltSJA5HZGV0+Aln3hliK+Kv3UqKC2cNc1r8MM=
Message-ID: <84144f020804231035w3fdb10aax4b90dc4e0bc1957d@mail.gmail.com>
Date: Wed, 23 Apr 2008 20:35:15 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Cc: "Ingo Molnar" <mingo@elte.hu>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080423101123.a69e4945.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804212310.41729.elendil@planet.nl>
	 <20080422134034.GF7311@elte.hu>
	 <20080422235148.c49dc6b7.zaitcev@redhat.com>
	 <Pine.LNX.4.64.0804231038210.26134@sbz-30.cs.Helsinki.FI>
	 <20080423101123.a69e4945.zaitcev@redhat.com>
X-Google-Sender-Auth: ae236563e9d9c17e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 8:11 PM, Pete Zaitcev <zaitcev@redhat.com> wrote:
>  > --- a/drivers/usb/mon/mon_text.c
>  > +++ b/drivers/usb/mon/mon_text.c
>  > @@ -449,6 +449,7 @@ static struct mon_event_text *mon_text_read_wait(struct mon_reader_text *rp,
>  >               if (file->f_flags & O_NONBLOCK) {
>  >                       set_current_state(TASK_RUNNING);
>  >                       remove_wait_queue(&rp->wait, &waita);
>  > +                     kmem_cache_free(rp->e_slab, ep);
>  >                       return ERR_PTR(-EWOULDBLOCK);
>
>  The code looks like this:
>
>         while ((ep = mon_text_fetch(rp, mbus)) == NULL) {
>
>                 if (file->f_flags & O_NONBLOCK) {
>                         set_current_state(TASK_RUNNING);
>                         remove_wait_queue(&rp->wait, &waita);
>                         return ERR_PTR(-EWOULDBLOCK);
>
>  It's impossible to get inside the while() with non-null ep,
>  so your patch doesn't fix anything (even if kmem_cache_free
>  can survive a NULL object).

Yeah, I need a new pair of glasses. Thanks.

On Wed, Apr 23, 2008 at 8:11 PM, Pete Zaitcev <zaitcev@redhat.com> wrote:
>  Any other ideas?

Well, a race in mon_text_release() after the kmem_cache_free() loop
and the call to kmem_cache_destroy() but looks like that can't happen
either. Frans, is this easily triggerable? If so, can you try with
CONFIG_SLAB and CONFIG_DEBUG_SLAB enabled instead?
