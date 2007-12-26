Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbXLZT7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbXLZT7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 14:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXLZT67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 14:58:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:32778 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXLZT66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 14:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WPrmuESG5XgNHEvWpw0ZgC3dbqrUXCGZPkVzofNms0Hjs+s6hf9slouTF8GMdNTmU8saEW0qVGwWcDYLTITAXBVjSoGrafiLCAQ5x17fziW2cL/YmWG44vDdPbrig1GeLT/JvPms575vENj9FWX5ii3bvA9B6Ad3NUhxURoOVkA=
Message-ID: <2c0942db0712261158q34cddebeifceef6ceda683320@mail.gmail.com>
Date: Wed, 26 Dec 2007 11:58:56 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 1/4] fs/autofs: Use time_before, time_before_eq, etc.
Cc: hpa@zytor.com, autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0712261621000.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.58.0712261621000.1185@pc-041.diku.dk>
X-Google-Sender-Auth: 9d2fcfa295089040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 26, 2007 7:21 AM, Julia Lawall <julia@diku.dk> wrote:
> -               if (jiffies - ent->last_usage < timeout)
> +               if (time_before(jiffies, ent->last_usage + timeout))

I don't think this is a safe change? subtraction is always safe (if
you think about it as 'distance'), addition isn't always safe unless
you know the range. The time_before macro will expand that out to
(effectively):

  if ( (long)(ent->last_usage + timeout) - (long)(jiffies) < 0 )

which seems to introduce an overflow condition in the first term.

Dunno, I may be wrong (happens often), but at the very least what
you've transformed it into is no longer obviously correct, and so it's
not a great change.
