Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbXH3BcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbXH3BcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 21:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759444AbXH3BcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 21:32:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:17359 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbXH3BcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 21:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=XloWXD/VZb3TwcFX6FlMpYxgmM5eL2/VH9WSQy00ndbnww4Pd8gPcw0mG7zAmSAzlyRcLJwqBa55MOLt1eIpi11Tn2IOE4DJKlSADEKhM47InH6JygcEN0XHcvpt5g1RvJuaMZZU96W8CJckQSW5uMqErUl8nE3OQkMqRJTiJjk=
Date: Thu, 30 Aug 2007 09:33:13 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1: inlining failures in sound/pci/hda/hda_codec.c
Message-ID: <20070830013313.GA10349@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>On 8/23/07, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 22 Aug 2007 22:23:03 +0200,
> Mariusz Kozlowski wrote:
> > 
> > Hello,
> > 
> > 	This is from x86_32 with gcc 3.4.6:
> > 
> >   CC [M]  sound/pci/hda/hda_codec.o
> > sound/pci/hda/hda_codec.c: In function `snd_hda_codec_free':
> > sound/pci/hda/hda_codec.c:517: sorry, unimplemented: inlining failed
> > in
> call to 'free_hda_cache': function body not available
> > sound/pci/hda/hda_codec.c:534: sorry, unimplemented: called from
> > here
> > sound/pci/hda/hda_codec.c:517: sorry, unimplemented: inlining failed
> > in
> call to 'free_hda_cache': function body not available
> > sound/pci/hda/hda_codec.c:535: sorry, unimplemented: called from
> > here
> > make[3]: *** [sound/pci/hda/hda_codec.o] Error 1
> > make[2]: *** [sound/pci/hda] Error 2
> > make[1]: *** [sound/pci] Error 2
> > make: *** [sound] Error 2
> 
> Since it doesn't happen with gcc-4.x, this looks like a gcc-3.x
> specific problem.   Does the patch below fix?
> 
> 
> Taksahi
> 
> diff -r db9001b20d29 pci/hda/hda_codec.c
> --- a/pci/hda/hda_codec.c	Wed Aug 22 14:19:45 2007 +0200
> +++ b/pci/hda/hda_codec.c	Wed Aug 22 23:06:00 2007 +0200
> @@ -514,7 +514,7 @@ static int read_widget_caps(struct hda_c
>  
>  static void init_hda_cache(struct hda_cache_rec *cache,
>  			   unsigned int record_size);
> -static inline void free_hda_cache(struct hda_cache_rec *cache);
> +static void free_hda_cache(struct hda_cache_rec *cache);
>  
>  /*
>   * codec destructor
> @@ -707,7 +707,7 @@ static void __devinit init_hda_cache(str
>  	cache->record_size = record_size;
>  }
>  
> -static inline void free_hda_cache(struct hda_cache_rec *cache)
> +static void free_hda_cache(struct hda_cache_rec *cache)
>  {
>  	kfree(cache->buffer);
>  }
How about this one:

diff -uprN linux/sound/pci/hda/hda_codec.c linux.new/sound/pci/hda/hda_codec.c
--- linux/sound/pci/hda/hda_codec.c	2007-08-30 09:27:42.000000000 +0800
+++ linux.new/sound/pci/hda/hda_codec.c	2007-08-30 09:27:50.000000000 +0800
@@ -514,7 +514,11 @@ static int read_widget_caps(struct hda_c
 
 static void init_hda_cache(struct hda_cache_rec *cache,
 			   unsigned int record_size);
-static inline void free_hda_cache(struct hda_cache_rec *cache);
+
+static inline void free_hda_cache(struct hda_cache_rec *cache)
+{
+	kfree(cache->buffer);
+}
 
 /*
  * codec destructor
@@ -707,10 +711,6 @@ static void __devinit init_hda_cache(str
 	cache->record_size = record_size;
 }
 
-static inline void free_hda_cache(struct hda_cache_rec *cache)
-{
-	kfree(cache->buffer);
-}
 
 /* query the hash.  allocate an entry if not found. */
 static struct hda_cache_head  *get_alloc_hash(struct hda_cache_rec *cache,
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

