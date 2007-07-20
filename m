Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbXGTEU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbXGTEU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXGTEUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:20:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:55773 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXGTEUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XYhhMFELy3OiDI/3UOm55ljghEo6TIo6OEKDFp3r/GIxYHqJ4Bs/ch9P5NsDoYmoVzQ2hRUaNH2mnvnR5Ygbhi5Qt4NjiZ1sP0nJTw+mrD5WGcaNEJ0EghWHyNaJXudDuTT7C3mqhrhZ0PaEicjPQotBPQ6QrfwLIOLiFQPugU0=
Message-ID: <86802c440707192120v6b6de39ek811e4f7aed9faa45@mail.gmail.com>
Date: Thu, 19 Jul 2007 21:20:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] Memory leak in tpm_ascii_bios_measurements_open() fix.
Cc: "Reiner Sailer" <sailer@us.ibm.com>, "Jesper Juhl" <jesper.juhl@gmail.com>,
       kjhall@linux.vnet.ibm.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Seiji Munetoh" <munetoh@jp.ibm.com>,
       "Reiner Sailer" <sailer@watson.ibm.com>, stefanb@us.ibm.com
In-Reply-To: <a781481a0707192107g5bf71891qd289126220ca6189@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A02CED.7000309@us.ibm.com>
	 <a781481a0707192107g5bf71891qd289126220ca6189@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 7/20/07, Reiner Sailer <sailer@us.ibm.com> wrote:
> >
> > Jesper Juhl <jesper.juhl@gmail.com> wrote on 07/18/2007 07:11:54 PM:
> >  >
> >  > +++ b/drivers/char/tpm/tpm_bios.c
> >  > @@ -427,7 +427,7 @@ static int
> >  > tpm_ascii_bios_measurements_open(struct inode *inode,
> >  >        return -ENOMEM;
> >  >
> >  >     if ((err = read_log(log)))
> >  > -      return err;
> >  > +      goto out_free;
> >  >
> >  >     /* now register seq file */
> >  >     err = seq_open(file, &tpm_ascii_b_measurments_seqops);
> >  > @@ -435,10 +435,15 @@ static int
> >  > tpm_ascii_bios_measurements_open(struct inode *inode,
> >  >        seq = file->private_data;
> >  >        seq->private = log;
> >  >     } else {
> >  > -      kfree(log->bios_event_log);
> >  > -      kfree(log);
> >  > +      goto out_free;
> >  >     }
> >  > +
> >  > +out:
> >  >     return err;
> >  > +out_free:
> >  > +   kfree(log->bios_event_log);
> >  > +   kfree(log);
> >  > +   goto out;
> >  >  }
> >  >
===>
out_free:
   kfree(log->bios_event_log);
   kfree(log);
out:
   return err;

could kill one extra goto.

YH
