Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbZE0G5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbZE0G5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbZE0G5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:57:37 -0400
Received: from gw1.transmode.se ([213.115.205.20]:37871 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZE0G5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:57:36 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 02:57:36 EDT
In-Reply-To: <D7CCA83BB0796C49BC0BB53B6AB1208934920A@zch01exm21.fsl.freescale.net>
References: <D7CCA83BB0796C49BC0BB53B6AB1208934920A@zch01exm21.fsl.freescale.net>
Subject: Re: Net: ucc_geth ethernet driver optimization space
X-KeepSent: ED0E4273:051DFDD2-C12575C3:00246ED3;
 type=4; name=$KeepSent
To: "Liu Dave-R63238" <DaveLiu@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linuxppc-dev-bounces+joakim.tjernlund=transmode.se@ozlabs.org,
       netdev@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OFED0E4273.051DFDD2-ONC12575C3.00246ED3-C12575C3.0025759F@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 27 May 2009 08:49:09 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5 HF407|May 07, 2009) at
 2009-05-27 08:49:10
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



linuxppc-dev-bounces+joakim.tjernlund=transmode.se@ozlabs.org wrote on 27/05/2009 07:08:07:
>
> Guys,
>
> The ucc_geth ethernet driver have dozens of strong sync read/write
> operation, such as in_be32/16/8, out_be32/16/8.
>
> all of them is sync read/write, it is very expensive for performance.
>
> For the critical patch, we can remove some unnecessary in_be(x),
> out_be(x) with normal memory operation, and keep some necessary
> memory barrier.
>
> eg: BD access in the interrupt handler and start_xmit.
>
> The BD operation only need the memory barrier between length/buffer
> and status.
>
> struct buffer descriptor {
>    u16 status;
>    u16 length;
>    u32 buffer;
> } __attribute__ ((packed));
>
> struct buffer descriptor *BD;
>
> BD->length = xxxx;
> BD->buffer = yyyy;
> wmb();
> BD->status = zzzz;
>
> For powerpc, eieio is enough for 60x, mbar 1 is enough for e500.
> Of couse, also need the memory clobber to avoid the compiler
> reorder between them.
>
> Thanks, Dave

Yes, pretty please :)

You might want to combine status and length into one U32 though:
BD->buffer = yyyy;
wmb();
BD->stat_len = zzzz << 16 | xxxx;

  Jocke

