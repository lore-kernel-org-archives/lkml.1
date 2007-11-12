Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbXKLANp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbXKLANp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 19:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbXKLANf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 19:13:35 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:27794 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbXKLANe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 19:13:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KBaRpo/PzMqk+i7U6arFUY5Wp2gT4SNIe64AqaDfg5uFQ3icweKxzKSbIpyj7oyVFxoUqT1zb09ghiLA28TbHwc43C66Y8b7ZB+aCFnpdcmGAetw3eQMLtevr6U0obexzllPTLjgIjGNkQ03Glt9LAT3TRbxUlEImE98hjUq03Q=
Message-ID: <9a8748490711111613s50f9e212k18f8106ee127e809@mail.gmail.com>
Date: Mon, 12 Nov 2007 01:13:33 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] Fix problem with size of allocation in libsas
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1194825603.3445.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711120024.54773.jesper.juhl@gmail.com>
	 <1194825603.3445.21.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2007, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2007-11-12 at 00:24 +0100, Jesper Juhl wrote:
> > From: Jesper Juhl <jesper.juhl@gmail.com>
> >
> > in sas_get_phy_change_count(), the line
> >       disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
> > will allocate 56 bytes due to this define:
> >       #define DISCOVER_RESP_SIZE 56
> > But, the struct is actually 60 bytes in size.
> >
> > So change the define to be
> >       #define DISCOVER_RESP_SIZE sizeof(struct smp_resp)
> > so we always get the correct size even when people
> > fiddle with the structure.
> >
> > This change also fixes the same problem in
> > sas_get_phy_attached_sas_addr()
> >
> > (Found by the Coverity checker. Compile tested only)
>
> Well, your fix is definitely wrong.
>
> Could you explain the problem a little more?  The discover response SMP
> frame is 56 bytes as mandated by the standard.  I don't see anywhere in
> the code where we're actually using a value beyond the 56th byte ...
> where is the problem use?
>

I haven't found any actual problem *use*, I just looked at the size of
'struct smp_resp' and noticed that coverity seemed to be right that 56
bytes are not sufficient to hold the members of the struct.  There are
32 bytes in the first members + the union and I don't see how that can
ever stay at 56 bytes...?  So, we are allocating memory and storing it
in a 'struct smp_resp *', but we are allocating less than
sizeof(smp_resp) - how is that not a (potential) problem?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
