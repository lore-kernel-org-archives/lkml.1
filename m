Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0BAOsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:48:25 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:60503 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab0BAOsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:48:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=i154k/fYaG7gOY8wKJsxc7nXOc70jvStQ8hIzcxyfyLrvcaQ5Sx3g4YaMX1bHV00hc
         VNKk+YSJB1zNrF/NC1RZ5mGNIHtqyvqCEOtGKI7q6YiaZcNyHSWrVW6U35ANQxnjtfe4
         XJyIJmZGSnPqmgPojFCb7dwN7rJp7wbFfQeZM=
MIME-Version: 1.0
In-Reply-To: <1265023437.2848.30.camel@edumazet-laptop>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant>
	 <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
	 <1265019160.2848.14.camel@edumazet-laptop>
	 <b6fcc0a1002010225u4e74f9f0q633d73038234dc37@mail.gmail.com>
	 <1265023437.2848.30.camel@edumazet-laptop>
Date: Mon, 1 Feb 2010 16:48:16 +0200
Message-ID: <b6fcc0a1002010648k5a27c2dey12c1cdcb0790a33@mail.gmail.com>
Subject: Re: debug: nt_conntrack and KVM crash
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jon Masters <jonathan@jonmasters.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 1:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> I wrote the algos, I know that we need different slab caches, for sure,
> this is not something I can _measure_, but theory can predict.
>
> SLAB_DESTROY_BY_RCU has very special semantics, you can ask Paul E.
> McKenny for details if you dont trust me.
>
> If you use a shared slab cache, one object can instantly flight between
> one hash table (netns ONE) to another one (netns TWO), and concurrent
> reader (doing a lookup in netns ONE, 'finding' an object of netns TWO)
> can be fooled without notice, because no RCU grace period has to be
> observed between object freeing and its reuse.
>
> We dont have this problem with UDP/TCP slab caches because TCP/UDP
> hashtables are global to the machine (and each object has a pointer to
> its netns).

conntracks also have netns pointer (->ct_net). This should be enough, yes?

> If we use per netns conntrack hash tables, we also *must* use per netns
> conntrack slab caches, to guarantee an object can not escape from one
> namespace to another one.
