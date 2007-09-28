Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbXI1LqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbXI1LqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXI1LqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:46:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:21881 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXI1LqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=azX16uTvwiOD1S65kPTLzJDhWmDrKWjERNdXgl94TpzIzvQD+hJHAOL+a70yNIROkDlhrVmP0Oo4mmCKXm6z3Ar04Lyu2+fuW8GI9/rHUByQRI6UQPu3GGtgeUml4L0tb12ZKiyDexf2g3Crx+cAXtkY1H7hR7sIed7v4iDR/eA=
Message-ID: <19f34abd0709280446l47584141m4f89fe4d2eb6926d@mail.gmail.com>
Date: Fri, 28 Sep 2007 13:46:00 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [RFC] New kernel-message logging API (take 2)
Cc: LKML <linux-kernel@vger.kernel.org>, "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <Pine.LNX.4.64.0709280922230.32185@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
	 <Pine.LNX.4.64.0709280922230.32185@anakin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If-blocks spanning macros are really dangerous!
>
> E.g. an Ethernet driver may want to do:
>
>         kprint_block(&block, "MAC ");
>         for (i = 0; i < 6; i++) {
>                 card->mac[i] = obtain_mac_byte_from_hw(i);
>                 kprint_block(&block, "%02x", card->mac[i]);
>         }
>
> This looks (and should be) innocent, but the actual MAC addres retrieval
> would never be executed if loglevel <= CONFIG_KPRINT_LOGLEVEL_MAX.

Yup. Okay, so it's definitely NOT an option.

> Can't you store the loglevel in the kprint_block and check it in all
> successive kprint_*() macros? If gcc knows it's constant, it can optimize
> the non-wanted code away. As other fields in struct kprint_block cannot be
> constant (they store internal state), you have to split it like:
>
>     struct kprint_block {
>             int loglevel;
>             struct real_kprint_block real;  /* internal state */
>     }
>
> and pass &block.real() instead of &block to all successive internal functions.
> I haven't tried this, so let's hope gcc is actually smart enough...

It isn't, apparently. Or not with my test, anyway. Either way, it's
probably better not to make those assumptions about or rely too much
on the smartness of the compiler (we don't have *any* guarantees).

The best solution for now is probably to pass the log-level into each
line, as Dick Streefland suggested, though it would lead to a hairier
syntax, or just skip the whole interface for now, as Jan Engelhardt
suggested. Thanks.

Vegard
