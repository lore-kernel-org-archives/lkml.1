Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZLIO7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZLIO7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZLIO7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:59:37 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64765 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZLIO7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:59:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UQ2O2vA7BxykWydjNg2SW2l3QwKqgFZ8KKQDjaPV2Lf8mpDG56JHWXT/eEImZoTTxM
         UBgHobzy8bsm75w1V8GGBMCvja83yjLrcYUkrVptgw3VbkTUuPA6HWF8KGk6M/0SePok
         0+zK1KxmRbODZKoI0o5Lo1RHOykEpWDa0JmLo=
Date: Wed, 9 Dec 2009 15:59:05 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, John Daiker <daikerjohn@gmail.com>,
       kernel-janitors@vger.kernel.org, aia21@cantab.net,
       linux-ntfs-dev@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NTFS: Change string pointers to string constants.
Message-ID: <20091209145846.GA3562@joi.lan>
References: <1259808806-27279-1-git-send-email-daikerjohn@gmail.com>
 <C1806924-DE57-4FBA-A67C-85C618FE6639@cam.ac.uk>
 <1260236833.3215.237.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260236833.3215.237.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 05:47:13PM -0800, Joe Perches wrote:
> On Tue, 2009-12-08 at 00:57 +0000, Anton Altaparmakov wrote:
> > Can you please explain the rational for making this change?
> 
> Perhaps it's not worth much, but it saves a pointer reference.
> 
> $ cat pointer.c
> #include <string.h>
> #include <stdio.h>
> 
> int main (int argc, char** argv)
> {
> 	static const char *foo = "abcdefg";
> 	printf("%s\n", foo);
> 	return 0;
> }
> 
> $ gcc -c pointer.c
> $ size pointer.o
>    text	   data	    bss	    dec	    hex	filename
>      37	      4	      0	     41	     29	pointer.o
> 
> $ cat reference.c
> #include <string.h>
> #include <stdio.h>
> 
> int main (int argc, char** argv)
> {
> static const char foo[] = "abcdefg";
> printf("%s\n", foo);
> return 0;
> }
> 
> $ gcc -c reference.c
> $ size reference.o
>    text    data     bss     dec     hex filename
>      36       0       0      36      24 reference.o

Yeah, for static variables it's better. But for automatic variables
it's worse, because it now has to do a copy at runtime.
And the patch changes both types.

$ size pointer.o reference.o
   text    data     bss     dec     hex filename
    101       8       0     109      6d pointer.o
     96       0       0      96      60 reference.o

$ size pointer-nonstatic.o reference-nonstatic.o
   text    data     bss     dec     hex filename
    106       0       0     106      6a pointer-nonstatic.o
    109       0       0     109      6d reference-nonstatic.o
