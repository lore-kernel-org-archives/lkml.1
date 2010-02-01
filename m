Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab0BALYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 06:24:05 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:48404 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0BALYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 06:24:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ALAqi15ZBIGUVXC90q+7J7YujDubyqf0Vfb2m+stECFAth4/NZiOSHgKQWk0TtGtjm
         FMtqaJJQGQh6K7rXzxFfh/XkLwqjPXGOylypL+Z/LzvNs2qElH9H0EQirF9Pd7/M9PUm
         4kB9Pkg8lUSRoh66uOzzCKP1ZoDaqHgRJjAnM=
Subject: Re: debug: nt_conntrack and KVM crash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jon Masters <jonathan@jonmasters.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <b6fcc0a1002010225u4e74f9f0q633d73038234dc37@mail.gmail.com>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant> <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
	 <1265019160.2848.14.camel@edumazet-laptop>
	 <b6fcc0a1002010225u4e74f9f0q633d73038234dc37@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 12:23:57 +0100
Message-ID: <1265023437.2848.30.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 01 février 2010 à 12:25 +0200, Alexey Dobriyan a écrit :

> > 2) nf_conntrack_cachep is shared, it should be not shared.
> 
> There is no need for it to be shared, unless you measured something.
> 

I wrote the algos, I know that we need different slab caches, for sure,
this is not something I can _measure_, but theory can predict.

SLAB_DESTROY_BY_RCU has very special semantics, you can ask Paul E.
McKenny for details if you dont trust me.

If you use a shared slab cache, one object can instantly flight between
one hash table (netns ONE) to another one (netns TWO), and concurrent
reader (doing a lookup in netns ONE, 'finding' an object of netns TWO)
can be fooled without notice, because no RCU grace period has to be
observed between object freeing and its reuse.

We dont have this problem with UDP/TCP slab caches because TCP/UDP
hashtables are global to the machine (and each object has a pointer to
its netns).

If we use per netns conntrack hash tables, we also *must* use per netns
conntrack slab caches, to guarantee an object can not escape from one
namespace to another one.



