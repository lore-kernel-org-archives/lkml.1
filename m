Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbZKMQmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbZKMQmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbZKMQmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:42:55 -0500
Received: from ns.firmix.at ([62.141.48.66]:4502 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402AbZKMQmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:42:54 -0500
Subject: Re: sizeof vs strlen (was Re: [PATCH 4/4] fs/qnx4: decrement
 sizeof size in strncmp)
From: Bernd Petrovitsch <bernd@firmix.at>
To: Julia Lawall <julia@diku.dk>
Cc: al@alarsen.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0911121632540.19779@ask.diku.dk>
References: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk>
	 <1258021335.3689.41.camel@tara.firmix.at>
	 <Pine.LNX.4.64.0911121632540.19779@ask.diku.dk>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 13 Nov 2009 17:42:46 +0100
Message-Id: <1258130566.27859.4.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.107 () AWL,BAYES_00,FORGED_RCVD_HELO,SARE_SUB_6CONS_WORD,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.107 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Fri, 13 Nov 2009 17:42:59 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 16:33 +0100, Julia Lawall wrote: 
> On Thu, 12 Nov 2009, Bernd Petrovitsch wrote:
> 
> > On Thu, 2009-11-12 at 08:49 +0100, Julia Lawall wrote:
> > > From: Julia Lawall <julia@diku.dk>
> > > 
> > > As observed by Joe Perches, sizeof of a constant string includes the
> > > trailing 0.  If what is wanted is to check the initial characters of
> > > another string, this trailing 0 should not be taken into account.  If an
> > > exact match is wanted, strcmp should be used instead.
> > [...]
> > > strncmp(foo, abc, 
> > > - sizeof(abc)
> > > + sizeof(abc)-1
> > >  )
> > > // </smpl>
> > Am I the only one who find "strlen()" instead of "sizeof()-1" here much
> > more readable (and to the point).
> > 
> > As for run-time, it shouldn't make a difference for static/constant
> > strings as gcc should be able calculate the length at compile time. And
> > if the string is not constant, sizeof() is probably wrong anyways.
> 
> Does gcc have access to the definition of strlen?  It does not seem to be 
> an inlined function, eg in lib/string.c.
Since "strlen()" is defined in the C-Standard C-compilers could rely on
the defined behaviour (but I don't know exactly how gcc behaves with
-ffreestanding for all supported versions).
Then there is __builin_strlen() (see also
http://gcc.gnu.org/onlinedocs/gcc-4.4.2/gcc/Other-Builtins.html#Other-Builtins).

Stepping a quite small abstraction layer higher:
include/linux/string.h has at teh end:
----  snip  ----
static inline bool strstarts(const char *str, const char *prefix)
{
	return strncmp(str, prefix, strlen(prefix)) == 0;
}
---- snip  ----
seems to be what most uses of strnmcp() actually are: check if one
string is a prefix of another.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


