Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbZIOSsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbZIOSsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbZIOSsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:48:11 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:40988 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047AbZIOSsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:48:10 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 15 Sep 2009 11:48:09 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: adi hodos <thefatredguy@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Suggested addition to epoll interface -
 epoll_post_notification()
In-Reply-To: <2517f1930909150559p505b583fpf3501a1c7dad6634@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0909151143070.20414@makko.or.mcafeemobile.com>
References: <2517f1930909150559p505b583fpf3501a1c7dad6634@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009, adi hodos wrote:

> Hello everyone. Thank you for your time in reading this.
> I have been playing with epoll lately and I would like to make a suggestion
> regarding the epoll interface.
> It would be nice to have a function to wake up a thread/process that is blocked
> on an epoll_wait() call and sent it some
> user defined data in the form of a struct epoll_event parameter ( something
> similar with PostQueuedCompletionStatus() from Windows ).
> My suggestion is for a function like this : int epoll_post_notification( int
> epoll_descriptor , struct epoll_event* event );
> It could be of much help in scenarios like these :
> 
> int e_accept;
> int e_clients;
> 
> typedef enum {
>  keycode_client_connection ,
>  keycode_signal ,
>  keycode_socketio ,
>  keycode_fileio ,
>  keycode_event ,
>  keycode_timer
>  ....
> } event_key_type;
> 
> struct event_key {
>   event_key_type keycode;
> };
> 
> struct eventfd_wrapper {
>  struct eventkey ek;
>  int fd_event;
> };
> 
> struct signalfd_wrapper {
>  struct eventkey ek;
>  int fd_signal;
> };
> 
> struct client {
>  struct event_key ek;
>  int sock;
>  ....
> };
> 
> struct user_posted_event {
>  struct event_key ek;
>  union {
>   void*    ptr_data;
>   int      i_data;
>   uint32_t u32;
>   uint32_t u64;
>  } u;
> };
> 
> 
> // thread A - waits for client connections using an epoll interface
> for ( ; ; ) {
>  epoll_wait( e_accept , ... );
> 
>  int s = accept();
>  struct client* new_client = allocate_newclient();
>  new_client->sock = s;
>  struct user_posted_event* ue = allocate_newuserevent();
>  ue->ek.keycode = keycode_client_connection;
>  ue->u.ptr_data = new_client;
> 
>  struct epoll_event e;
>  e.data.ptr = ue;
>  epoll_post_notification( e_clients , &e );
> }
> 
> // thread b - serves clients
> for( ; ; ) {
>  struct epoll_event[..] e;
>  epoll_wait( e_clients , e , ... );
> 
>  struct event_key* key = ( struct event_key* )( e.data.ptr );
>  if( key->keycode == keycode_client_connection ) {
>    // handle new client connection
>  } else if( key->keycode == keycode_signal ) {
>    // handle signal
>  } else if( .... ) {
>   ...
>  }
> 
> Again , thank you for your time in reviewing this.

Just use a pipe(2) to send data from A to B.
The read-side of the pipe will be in thread B epoll set, thread A would 
prepare and write(2) a "message" (binary struct really), and thread B 
would be wake up and read(2) the message.
no need to add anything.
Do you really have a dedicated thread for accepts though?


- Davide


