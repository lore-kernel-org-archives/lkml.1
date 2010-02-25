Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab0BYRJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:09:43 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:61578 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759333Ab0BYRJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:09:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19334.44752.357207.382349@pilspetsen.it.uu.se>
Date: Thu, 25 Feb 2010 18:09:36 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Brian Gerst <brgerst@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Roel Kluin <roel.kluin@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in 
	sha1_update()
In-Reply-To: <73c1f2161002250833n120cda05s9371e5ce13cc0aac@mail.gmail.com>
References: <4B8692E3.9030509@gmail.com>
	<19334.40337.651079.440912@pilspetsen.it.uu.se>
	<73c1f2161002250833n120cda05s9371e5ce13cc0aac@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> Would barrier() (which is a simple memory clobber) after the memset work?

I don't know. It's implemented as an asm with a "memory" clobber,
but I wouldn't bet on that forcing previous writes to a dying object
to actally be performed (it would have to have a data-dependency on
the dying object, but I don't think there is one).

void secure_bzero(void *p, size_t n)
{
	memset(p, 0, n);
	asm("" : : "m"(*(char*)p));
}

seems to work, but as the object in general will be larger than a
single byte, I'd like to see some confirmation from the gcc folks
first that this will in fact work.
