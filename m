Return-Path: <linux-kernel-owner+w=401wt.eu-S934856AbXHJMYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934856AbXHJMYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbXHJMX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:23:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:35533 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbXHJMX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tx051H9OMTjTj/fBMtlPKNPYAG/5RouFRUniisHejVv7HclcfmIpmRgvxizAwZnnwTdGJ07lw3K3SfUbV0h5LdrW3N6u7X5zRiM3wS0m3rq06p0RR6kudow6lppdhNZo4k6c40+qwqjsWNRLWyxZXP1pbbRaS5BhMF/3t+unH9c=
Message-ID: <3ae72650708100523w45b4d5cbxf0ffbdc11cfb5e45@mail.gmail.com>
Date: Fri, 10 Aug 2007 14:23:56 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: [PATCH] Fix OOPS in show_uevent()
Cc: "Greg KH" <gregkh@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, devel@openvz.org
In-Reply-To: <46BC3A57.5070404@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46BC3A57.5070404@openvz.org>
X-Google-Sender-Auth: 0b01bd71dd121c05
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/07, Pavel Emelyanov <xemul@openvz.org> wrote:
> The platform_uevent() callback called via
>   show_uevent()
>   dev_uevent()
>   platform_uevent()
> forgot to set NULL to the last envp pointer and this caused the
> show_uevent() oops while printing all the envp pointers like this:

> The last hunk in this patch fixes this.

Looks like the right fix, yes.

> The other problem is that the envp passed to bus, type and platform callbacks
> from dev_uevent() is the same, so the callbacks can overwrite the info, written
> by the others. Did I miss something important?

Sounds like a bug, yes.

But we still don't update the remaining buffer size and the remaining
array fields which are left after the call. Shouldn't we instead just
change the:
   int (*dev_uevent)(struct device *dev,
                                char **envp, int num_envp,
                                char *buffer, int buffer_size);
to:
  int (*dev_uevent)(struct device *dev,
                               char **envp, int num_envp, int *cur_index,
                               char *buffer, int buffer_size, int *cur_len);

like we do for:
  int add_uevent_var(char **envp, int num_envp, int *cur_index,
                                  char *buffer, int buffer_size, int *cur_len,
                                  const char *format, ...)

and along with the change of the callers, we would update the values
properly, so the next call has the correct numbers? There are 6
classes and something like 12 buses using this method, so it shouldn't
be too much trouble.

Thanks,
Kay
