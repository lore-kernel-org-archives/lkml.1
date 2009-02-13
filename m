Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZBMJXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZBMJXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZBMJXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:23:05 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:23913 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZBMJXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ldSdXh+G2yw5/lKjSqPTO/RX91L+6jvmvQKGvyJgNYoGoZjNXnfJ0cRRvnmgtpn2Zo
         G2jx9SPqOpUwYAWMddm1QLqutAPEZqS4vwYHBimDJxTj5kfIFJXFrauOnciXhlRPvvdC
         gGzzsgwfeEWycSTE+7OJqWacH8MMNL09nfDv8=
MIME-Version: 1.0
In-Reply-To: <499544AD.3030804@st.com>
References: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>
	 <20090212185640.GA6111@linux-sh.org> <499544AD.3030804@st.com>
Date: Fri, 13 Feb 2009 11:22:58 +0200
X-Google-Sender-Auth: d65e9bd89bba96b4
Message-ID: <84144f020902130122y471dd92em4a72de43a0cfc681@mail.gmail.com>
Subject: Re: [PATCH] slab: fix slab flags for archs use alignment larger 
	64-bit
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-mm@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Giuseppe,

On Fri, Feb 13, 2009 at 12:00 PM, Giuseppe CAVALLARO
<peppe.cavallaro@st.com> wrote:
> IIUC, and as you explained above, ralign is already set to the cache
> line size by the following code:
> ...
> /* 3) caller mandated alignment */
> if (ralign < align)
> ralign = align;
>
> Then, there is following check:
> ...
> /* disable debug if necessary */
> if (ralign > _alignof__(unsigned long long))
> flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>
> In my point of view, just this check appears "incoherent" (please, note
> I'm not familiar with the slab internals).
> It always makes sense in case of x86 where ARCH_KMALLOC_MINALIGN is
> defined as: __alignof__(unsigned long long) as well.

The code is indeed quite cryptic but I don't think the above statement
is correct. Both SLAB_RED_ZONE and SLAB_STORE_USER add padding in
front of an object and the maximum size of that padding is 2 *
sizeof(unsigned long long). That's why we check for
__alignof__(unsigned long) there to make sure the object can begin
immediately after the padding added for red-zone and user pointer.

On Fri, Feb 13, 2009 at 12:00 PM, Giuseppe CAVALLARO
<peppe.cavallaro@st.com> wrote:
> In case of sh, we always disable debug for 32 aligned objects. As side
> effect, within the leaks_show function we immediately exit for them.
> Indeed, after applying the patch, I attached, I was able to find size-X
> fields within the slab_allocators proc entry.

That sounds unfortunate. Can you post

  cat /proc/meminfo | grep Slab

results on sh without and with your patch? Bumping the limit up to
ARCH_KMALLOC_MINALIGN does make sense but we'd need to know what kind
of problems it might cause.

                                Pekka
