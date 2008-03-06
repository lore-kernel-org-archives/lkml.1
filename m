Return-Path: <linux-kernel-owner+w=401wt.eu-S1762746AbYCFXgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746AbYCFXgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 18:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbYCFXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 18:36:45 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:60876 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237AbYCFXgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 18:36:44 -0500
Message-ID: <47D07FDC.2010701@tiscali.nl>
Date: Fri, 07 Mar 2008 00:35:56 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: elf@buici.com, Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] locomo.c: convert strncpy(x, y, sizeof(x)) to strlcpy
References: <47CFECCB.7050909@tiscali.nl> <47D065DB.7070708@zytor.com>
In-Reply-To: <47D065DB.7070708@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Roel Kluin wrote:
>> This patch was not yet tested. Please confirm it's right.
>> ---
>> strncpy does not append '\0' if the length of the source string equals
>> the size parameter, strlcpy does.
>>
> 
> Are you sure it's safe to not zero out the contents of the buffer (no
> information leak)?
> 
>     -hpa

As I understand it, please correct me if I'm wrong:

Of the three variants: strcpy, strncpy and strlcpy.
- strcpy does not append \0 (unless the source string already contained it)
- strncpy appends \0's if the source string is smaller than the size
  parameter (for all remaining characters)
- strlcpy always appends a single \0 (unless size parameter was 0)

char *strcpy(char *dest, const char *src);
char *strncpy(char *dest, const char *src, size_t n);
size_t strlcpy(char *dst, const char *src, size_t n);

In the original code strncpy was used and the size parameter was equal
to the source string size:

strncpy(dev->dev.bus_id, info->name, sizeof(dev->dev.bus_id));

Since this the size was equal there was no \0 termination. To \0
terminate using strncpy we could write:

strncpy(dev->dev.bus_id, info->name, sizeof(dev->dev.bus_id) - 1);
dev->dev.bus_id[sizeof(dev->dev.bus_id) - 1] = '\0';

or using strlcpy, which does the same thing:

strlcpy(dev->dev.bus_id, info->name, sizeof(dev->dev.bus_id));

Roel
