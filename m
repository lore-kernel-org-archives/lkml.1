Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbZDBMa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbZDBMa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbZDBMaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:30:20 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:63134 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549AbZDBMaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cPJTjzdd5H5i/9fui9ZL/+9bJKzce2qe/Nd+2Kb8Dpj6QsFLutBUAHdKtHq/ISaoFj
         w4NKIl3Ol9dwEv6lEhwIu6Nldl4pu2tZg4v8akfmrajMguLjfnzOuhHF1WM9kKNZts0l
         KV0oMD3C1+YfGGW6RYQI7GTeusgquCGmh6Dg0=
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Andreas Robinson <andr345@gmail.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Arjan van de Ven <arjan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
In-Reply-To: <1238629202.9027.111.camel@nigel-laptop>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
	 <49D3D4C0.1080506@zytor.com> <1238624827.15230.58.camel@andreas-desktop>
	 <49D3EDEA.4090803@zytor.com>  <49D3F4A3.1040609@linux.intel.com>
	 <1238629202.9027.111.camel@nigel-laptop>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 14:30:10 +0200
Message-Id: <1238675410.13249.42.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 10:40 +1100, Nigel Cunningham wrote:
> Sorry to jump in with a tangential issue, but I just noticed the
> thread
> and it reminded me of an issue :)
> 
> Should the lzo code used via cryptoapi (I believe it's the same stuff)
> be SMP safe? I've tried to use it work TuxOnIce and get image corruption
> (test kernel is 64 bit). The same code works fine if I tell it to use
> LZF (which comes with TuxOnIce), no compression or, IIRC, work single
> threaded.

Do you compress or decompress data through the crypto API?

Neither function modifies the input data and there are no static or
global variables in use, so there shouldn't be a problem there.

They do however modify the destination length argument.

But most importantly, each compressor thread needs a private work buffer
allocated through lzo_init() in crypto/lzo.c. So, if you use the crypto
API to compress and share the crypto_tfm struct among threads, that
would explain your breakage.

Cheers,
Andreas

