Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYIIKYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYIIKYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYIIKYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:24:13 -0400
Received: from mailgw.infracomspa.it ([217.12.183.244]:4185 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751826AbYIIKYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:24:12 -0400
X-Greylist: delayed 919 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 06:24:12 EDT
Message-ID: <48C64B2B.6060808@infracom.it>
Date: Tue, 09 Sep 2008 12:08:43 +0200
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Organization: Infracom Network Application
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Roberto Oppedisano <roppedisano@infracomspa.it>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] rate limit drm:radeon_cp_idle/reset errors
References: <20080906091919.GA5021@infracomspa.it> <20080908210836.fc5df672.akpm@linux-foundation.org> <20080909073732.GA7563@infracomspa.it> <20080909011211.e336d7c4.akpm@linux-foundation.org> <alpine.DEB.0.82.0809090914300.1221@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.0.82.0809090914300.1221@skynet.skynet.ie>
X-Enigmail-Version: 0.95.7
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 09/09/2008 12:08:45 PM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 09/09/2008 12.24.12,
	Serialize complete at 09/09/2008 12.24.12
X-TM-AS-Product-Ver: <SMD>-<3.0.1.3628>-<5.5.1027>-<16132>
X-TM-AS-Result: <No>-<-10012.534>-<5.0>-<99000>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie ha scritto, Il 09/09/2008 10.15:
>>>>> Sep  6 10:24:31 poppero1 kernel: [  186.138774] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
>>>>> Sep  6 10:24:31 poppero1 kernel: [  186.138968] [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held, held  0 owner f726bc80 f68f6840
>>>>> Sep  6 10:24:31 poppero1 kernel: [  186.139214] [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held, held  0 owner f726bc80 f68f6840
>>>>> Sep  6 10:24:31 poppero1 kernel: [  186.139408] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
>>>>> Sep  6 10:24:31 poppero1 kernel: [  186.139601] [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held, held  0 owner f726bc80 f68f6840
>>>>> Sep  6 10:24:31 poppero1 kernel: [  186.139866] [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held, held  0 owner f726bc80 f68f6840
>>>>> Sep  6 10:24:31 poppero1 kernel: [  186.140072] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
>>>>> Sep  6 10:24:31 poppero1 kernel: [  186.140467] [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held, held  0 owner f726bc80 f68f6840
>>>>> Sep  6 10:24:36 poppero1 kernel: [  191.139019] __ratelimit: 253431 callbacks suppressed
>>>>> Sep  6 10:24:36 poppero1 kernel: [  191.139030] [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held, held  0 owner f726bc80 f68f6840
>>>>> Sep  6 10:24:36 poppero1 kernel: [  191.139314] [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner f726bc80 f68f6840
>>>>>
>>>>> Also if it doesn't solve a bug I think it may still be worth applying it. 
>>>>> Patch is against current git.
>>>>>
>>>>> Signed-off-by: Roberto Oppedisano <roberto.oppedisano@infracom.it>
>>>>>
>>>>> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
>>>>> index 1c1b13e..1107361 100644
>>>>> --- a/include/drm/drmP.h
>>>>> +++ b/include/drm/drmP.h
>>>>> @@ -162,7 +162,8 @@ struct drm_device;
>>>>>   * \param arg arguments
>>>>>   */
>>>>>  #define DRM_ERROR(fmt, arg...) \
>>>>> -	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __func__ , ##arg)
>>>>> +	if (printk_ratelimit()) \
>>>>> +		printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __func__ , ##arg)
>>>>>  
>>>>>  /**
>>>>>   * Memory error output.
>>>>>
>>>> Which kernel version(s)?
>>> This is against vanilla current git. 
>>>
>>> Linux poppero1 2.6.27-rc5-00000-g7686ad5-dirty #1 PREEMPT Sun Sep 7 08:47:08 CEST 2008 i686 GNU/Linux
>>>
>> Thanks.  I should have asked earlier: was 2.6.26 OK?  Any other kernels
>> tested?
> 
> This looks like a userspace problem, some app is accessing the drm file 
> descriptror without holding the drm lock, this is very illegal.
> 
> Its probably a race between the X server and the AIGLX driver.
> 
> Dave.

I also think it's a userspace problem. I found it while playing with
KDE4.1 kwin/Compiz, less than a month ago, always running on a current
vanilla git kernel: I noticed the syslog storm only recently (my bad,
because judging from the disk light I think it has always been there).

If you think it's useful I can do some test with older kernels (will
take some time btw).
R
