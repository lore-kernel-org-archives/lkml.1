Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbZA3J7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbZA3J7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZA3J7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:59:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:50050 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZA3J7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:59:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nb0DTu9C5LsOZCs9On8xcPjNmB8I0Fg9tPZP/B04gfwtvUBPZSe2ZGNYffrCV3d+Jy
         QnEGkrScgeCoav98m8gqom0YM4mV1WzzmiBbfzb3Bvfs0RU7mKyfBPJZWUgTh+gZFGeL
         e7AAIAGdoFlTDXDCDgePaVTwEp8/ppxTvHAMg=
MIME-Version: 1.0
In-Reply-To: <20090129210435.4ca393c4@infradead.org>
References: <1233282702-6274-1-git-send-email-tom.leiming@gmail.com>
	 <20090129210435.4ca393c4@infradead.org>
Date: Fri, 30 Jan 2009 17:59:04 +0800
Message-ID: <d82e647a0901300159g79680ed4h778ebb591861578c@mail.gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v2)
From: Ming Lei <tom.leiming@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: kay.sievers@vrfy.org, greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/30 Arjan van de Ven <arjan@infradead.org>:
> On Fri, 30 Jan 2009 10:31:42 +0800
> tom.leiming@gmail.com wrote:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> This patch renames driver_probe_done to driver_wait_probe_done,
>> and make it wait on condition of probing done to remove
>> polling for it in fs initialization. Also add
>> driver_wait_probe_done_and_dev_appear(name) to allow callers
>> to wait until all probing is done AND until the device @name
>> exists.
>
>>  /**
>> + * driver_wait_probe_done_and_dev_appear
>> + * wait until the probe sequence is finished _and_ the dev @name
>> appears.
>
> Hi,
>
> sorry to be the bad guy, but I think you turned the "either one" into a
> "both".... so this isn't going to work ;(

IMHO, it will msleep if either one is ture, so we turn this into
return( not sleep) if both are false.
( eg, A||B->C   <=>  ~C->~A&&~B )   :-)

           while (driver_probe_done() != 0 ||
                  (ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
                  msleep(100);
 here:
      driver_probe_done() == 0  &&  name_to_dev_t(saved_root_name)

===>

driver_wait_probe_done_and_dev_appear(name)
{
         if (driver_probe_done() == 0 &&
                  (ROOT_DEV = name_to_dev_t(saved_root_name)))
                  return;
         else
                  schedule();
}

Thanks!

>
> unless I'm just too tired and miss something subtle, but I am pretty
> sure DeMorgan does not work this way :)
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>



-- 
Lei Ming
