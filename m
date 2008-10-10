Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYJJCZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYJJCZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 22:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYJJCZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 22:25:25 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:34049 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752146AbYJJCZY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 22:25:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vYn213MDPlgsYjd4xUHvWn/kkEpMqXq/bhpKFYJIJr0A6l7KEqzbe7QaQE5fiOURgKmxCotYEsyjB9hld+hx42SU4mgJYepCDtkujfh0ZCnLq3PaPugAQowPzTASXhoLhjpLTx51L7eUausSrx4+GU6tsBfNxLpm4J0PaAZdLWs=  ;
X-YMail-OSG: y6pBlS0VM1l8HYap8TW.GLbX1f1y64CjearXfvA5UxGemaUDz26uNzPa1X1bGGdSXKEsPOVDuf5tPNBPQaxVeN6seeYHNxjY2_ItPhuLdAuVuNMEJMlu25LLDmE8nKiC9CpYlhuqHMIZN5mX6fgqG62s8V9MLvhejFB3Os5JrCGvo4V8SVUy9ee8Rl.P
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: dcg <diegocalleja@gmail.com>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Date: Fri, 10 Oct 2008 13:25:15 +1100
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <1223448711.1378.16.camel@lappy.programming.kicks-ass.net> <20081009235158.7d328aa0@diego-desktop>
In-Reply-To: <20081009235158.7d328aa0@diego-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810101325.16153.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2008 08:51, dcg wrote:
> El Wed, 08 Oct 2008 08:51:51 +0200, Peter Zijlstra <a.p.zijlstra@chello.nl> 
escribió:
> > either dup() the fd or open() the file twice. There is absolutely no
> > valid reason to have two threads read from the same fd without
> > synchronising their access to it - never.
>
> In case this is the final consensus, I think that a topic that is brought
> to the list every few months and even generates (aparently not neccesary)
> patches is a hint that there should be somewhere a commentary (*) like
> this:
>
> (*) I don't know if what I wrote is 100% correct.
>
>
> Signed-off-by: Diego Calleja García <diegocg@gmail.com>
>
> Index: 2.6/include/linux/fs.h
> ===================================================================
> --- 2.6.orig/include/linux/fs.h	2008-10-09 00:06:50.000000000 +0200
> +++ 2.6/include/linux/fs.h	2008-10-09 00:29:03.000000000 +0200
> @@ -821,6 +821,18 @@
>  	atomic_long_t		f_count;
>  	unsigned int 		f_flags;
>  	mode_t			f_mode;
> +	/*
> +	 * Linux does NOT guarantee atomic reading/writing to file->f_pos in
> +	 * multithread apps running in 32 bit machines. There're several
> +	 * reasons for this behaviour:

Note that I don't think we'd want to explicitly guarantee that it is atomic
on 64-bit machines either. It does happen to be, but I don't think we want
anybody to rely on that...
