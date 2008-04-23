Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYDWHfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYDWHfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYDWHfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:35:00 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:16687 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751282AbYDWHfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DvHUzR16pt+ZS0C0KMgeoG6T+LyipGipXlswxWnHTrI6UPhQXhEK5K1kM1RNQsbI8xr9bSnf0rbXOr6EVUZmztTKownaWvBtPF8YWXhjCDAlAnyK7MS3ZIPATBLN184YOFQQAfPiAF+8o7Ky46oSl8srw7vmMkjYlOQYy6rcOko=
Message-ID: <84144f020804230034y3d31fb02n597b69d7ed866260@mail.gmail.com>
Date: Wed, 23 Apr 2008 10:34:57 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Cc: "Ingo Molnar" <mingo@elte.hu>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <84144f020804230031w612176c1k8ec5a6fb27ca3315@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804212310.41729.elendil@planet.nl>
	 <20080422134034.GF7311@elte.hu>
	 <20080422235148.c49dc6b7.zaitcev@redhat.com>
	 <84144f020804230031w612176c1k8ec5a6fb27ca3315@mail.gmail.com>
X-Google-Sender-Auth: 9df1e87ebe7a45f4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 9:51 AM, Pete Zaitcev <zaitcev@redhat.com> wrote:
>  >  I looked at this whole day today, but found nothing.
>  >
>  >  The code analysis for usbmon shows nothing. Anyone wants to have
>  >  a look?

On Wed, Apr 23, 2008 at 10:31 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>  I didn't look too closely but mon_text_fetch() does list_del() but no
>  kmem_cache_free() which looks fishy.

Yup, looks like a leak in the error path. So it's mon_text_read_t() ->
mon_text_read_wait() -> mon_text_fetch() that removes it from the list
but we can fail before we reach the kmem_cache_free() in
mon_text_read_t() and thus lose track of the object.
