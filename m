Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZKTQIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZKTQIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbZKTQIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:08:54 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33241 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbZKTQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:08:53 -0500
Subject: Re: [PATCH 1/1] Defer skb allocation for both mergeable buffers
 and big packets in virtio_net
From: Shirley Ma <mashirle@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4B063509.10006@gmail.com>
References: <1258697745.7416.20.camel@localhost.localdomain>
	 <4B063509.10006@gmail.com>
Content-Type: text/plain
Date: Fri, 20 Nov 2009 08:08:52 -0800
Message-Id: <1258733332.4108.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 07:19 +0100, Eric Dumazet wrote:
> > +void virtio_free_pages(void *buf)
> > +{
> > +     struct page *page = (struct page *)buf;
> > +
> > +     while (page) {
> > +             __free_pages(page, 0);
> > +             page = (struct page *)page->private;
> > +     }
> > +}
> > +
> 
> Interesting use after free :)

Good catch. This code was run when virtio_net removal. I run many times
of remove virtio_net, and didn't hit any panic :(. Fixed it as below:

void virtio_free_pages(void *buf)
{
	struct page *page = (struct page *)buf;
	struct page *npage;

	while (page) {
		npage = page->private;
		__free_pages(page, 0);
		page = npage;
	}
}

Thanks
Shirley


