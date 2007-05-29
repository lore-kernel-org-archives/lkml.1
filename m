Return-Path: <linux-kernel-owner+w=401wt.eu-S1763600AbXE2SYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763600AbXE2SYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbXE2SYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:24:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:54425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbXE2SYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:24:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [RFC] Cell: shutdown method for spu_sysdev_class
Date: Tue, 29 May 2007 20:23:49 +0200
User-Agent: KMail/1.9.6
Cc: Geoff Levand <geoffrey.levand@am.sony.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
References: <463D1A2F.10708@am.sony.com>
In-Reply-To: <463D1A2F.10708@am.sony.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705292023.49968.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19UBPP2GWrqXSnSCuREIg0DdvcTB6ldrP++N32
 gCARWTkqbVtIIIUb6+3xy6I0Y3OG/pxqb4C+XArWiEVkxJy0j+
 kEY+aa8ocg8ENILQ/kSQg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 May 2007, Geoff Levand wrote:
> --- ps3-linux-dev.orig/arch/powerpc/platforms/cell/spu_base.c
> +++ ps3-linux-dev/arch/powerpc/platforms/cell/spu_base.c
> @@ -463,8 +463,21 @@ void spu_free(struct spu *spu)
>  }
>  EXPORT_SYMBOL_GPL(spu_free);
>
> +static int spu_shutdown(struct sys_device *sysdev)
> +{
> +       struct spu *spu = container_of(sysdev, struct spu, sysdev);
> +
> +       // what else here???
> +
> +       spu_free_irqs(spu);
> +       spu_destroy_spu(spu);
> +       kfree(spu);
> +       return 0;
> +}
> +
>  struct sysdev_class spu_sysdev_class = {
> -       set_kset_name("spu")
> +       set_kset_name("spu"),
> +       .shutdown = spu_shutdown,
>  };
>
>  int spu_add_sysdev_attr(struct sysdev_attribute *attr)

After some debugging, I found that this patch creates an oops when slab
debugging is enabled, the reason for that being that sysdev_shutdown()
iterates over all system devices using list_for_each_entry(), not
list_for_each_entry_safe().

There are two ways of fixing this:

- use list_for_each_entry_safe() to go over all devices so they
  can be freed in their ->shutdown method.
- not free the device, because we know the system is going down
  anyway.

Is it documented or implied somewhere that ->shutdown must not free
the device? If not, the first option is probably the safer choice.

	Arnd <><
