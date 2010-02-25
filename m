Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab0BYQ32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:29:28 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:55810 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab0BYQ30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:29:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19334.42332.984074.920727@pilspetsen.it.uu.se>
Date: Thu, 25 Feb 2010 17:29:16 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Roel Kluin <roel.kluin@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in 
	sha1_update()
In-Reply-To: <84144f021002250816o2c2cef0fke484c7e43256dba4@mail.gmail.com>
References: <4B8692E3.9030509@gmail.com>
	<19334.40337.651079.440912@pilspetsen.it.uu.se>
	<84144f021002250816o2c2cef0fke484c7e43256dba4@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg writes:
 > On Thu, Feb 25, 2010 at 5:56 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
 > > I fear that the only portable (across compiler versions) and safe
 > > solution is to invoke an assembly-coded dummy function with prototype
 > >
 > >        void use(void *p);
 > >
 > > and rewrite the code above as
 > >
 > >        {
 > >                u32 temp[...];
 > >                ...
 > >                memset(temp, 0, sizeof temp);
 > >                use(temp);
 > >        }
 > >
 > > This forces the compiler to consider the buffer live after the
 > > memset, so the memset cannot be eliminated.
 > 
 > So is there some "do not optimize" GCC magic that we could use for a
 > memzero_secret() helper function?

I guess there's some -fno-builtin-... that might achieve this effect,
but that would disable all memset optimizations, not just those affecting
sensitive data.

You'd want a function attribute or magic type annotation and apply it
only to the specific cases where it's needed. Alas, I know of no such
attribute or annotation. ('volatile' doesn't work, I tried that.)

Ask on gcc@gcc.gnu.org.
