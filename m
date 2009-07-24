Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbZGXRGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbZGXRGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 13:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZGXRGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 13:06:19 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:27168 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZGXRGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 13:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TTcP6D0tw7QMPK7y5uNTB5pR4O6o8syQdsKu25qaKTutN7e0IOs3tS4w547VAJj5cE
         2whvYWJ6TA88LWKgfnJLb7rr66dyUJOPIR5u8llYY4+80csNJijMrG/U98FgZLvZaysi
         8/9ooq5W/lYALIdEJhv25asB0ByYktnOzPJQk=
MIME-Version: 1.0
In-Reply-To: <4A69E164.9040403@ru.mvista.com>
References: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
	 <4A69E164.9040403@ru.mvista.com>
Date: Fri, 24 Jul 2009 14:06:16 -0300
Message-ID: <bad58e960907241006y22ac529dhfcccd4e1739b907c@mail.gmail.com>
Subject: Re: [PATCH] Removed useless retval variables in usb-serial.c
From: Trevor Pace <trevorpace@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

My university email account apparently doesn't like maintaining my
formatting, so I'm gonna resend this from my gmail.

Parenthesis may not be needed for that return check but I find it
makes it easier to tell that you are doing. Otherwise someone might
think you are returning serial->type->resume because it has been
broken onto different lines. I checked over the
Documentation/CodingStyle file and found no conflicts with that sort
of notation.

Trevor Pace

Lets try this again:

********************************************************************

Removed useless return value variables.

Signed-off By: Trevor Pace <trevor.pace@dal.ca>

================================================================================

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index bd7581b..faec1d1 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -362,10 +362,9 @@ static int serial_write(struct tty_struct *tty,
const unsigned char *buf,
 								int count)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	int retval = -ENODEV;

 	if (port->serial->dev->state == USB_STATE_NOTATTACHED)
-		goto exit;
+		return -ENODEV;

 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);

@@ -374,10 +373,7 @@ static int serial_write(struct tty_struct *tty,
const unsigned char *buf,
 	WARN_ON(!port->port.count);

 	/* pass on to the driver specific version of this function */
-	retval = port->serial->type->write(tty, port, buf, count);
-
-exit:
-	return retval;
+	return port->serial->type->write(tty, port, buf, count);
 }

 static int serial_write_room(struct tty_struct *tty)
@@ -429,7 +425,6 @@ static int serial_ioctl(struct tty_struct *tty,
struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	int retval = -ENODEV;

 	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);

@@ -437,11 +432,9 @@ static int serial_ioctl(struct tty_struct *tty,
struct file *file,

 	/* pass on to the driver specific version of this function
 	   if it is available */
-	if (port->serial->type->ioctl) {
-		retval = port->serial->type->ioctl(tty, file, cmd, arg);
-	} else
-		retval = -ENOIOCTLCMD;
-	return retval;
+	if (port->serial->type->ioctl)
+		return port->serial->type->ioctl(tty, file, cmd, arg);
+	return -ENOIOCTLCMD;
 }

 static void serial_set_termios(struct tty_struct *tty, struct ktermios *old)
@@ -1174,7 +1167,7 @@ int usb_serial_suspend(struct usb_interface
*intf, pm_message_t message)
 {
 	struct usb_serial *serial = usb_get_intfdata(intf);
 	struct usb_serial_port *port;
-	int i, r = 0;
+	int i;

 	serial->suspending = 1;

@@ -1185,24 +1178,21 @@ int usb_serial_suspend(struct usb_interface
*intf, pm_message_t message)
 	}

 	if (serial->type->suspend)
-		r = serial->type->suspend(serial, message);
+		return serial->type->suspend(serial, message);

-	return r;
+	return 0;
 }
 EXPORT_SYMBOL(usb_serial_suspend);

 int usb_serial_resume(struct usb_interface *intf)
 {
 	struct usb_serial *serial = usb_get_intfdata(intf);
-	int rv;

 	serial->suspending = 0;
-	if (serial->type->resume)
-		rv = serial->type->resume(serial);
-	else
-		rv = usb_serial_generic_resume(serial);

-	return rv;
+	return (serial->type->resume)
+		? serial->type->resume(serial)
+		: usb_serial_generic_resume(serial);
 }
 EXPORT_SYMBOL(usb_serial_resume);


******************************************************************


On Fri, Jul 24, 2009 at 1:29 PM, Sergei Shtylyov<sshtylyov@ru.mvista.com> wrote:
> Hello.
>
> Trevor Pace wrote:
>
>> Removed useless return value variables.
>
>   Are you sure gcc doesn't optimize them away? :-)
>
>> Signed-off By: Trevor Pace <trevor.pace@dal.ca>
>
>>
>> ================================================================================
>
>> diff --git a/drivers/usb/serial/usb-serial.c
>> b/drivers/usb/serial/usb-serial.c
>> index bd7581b..faec1d1 100644
>> --- a/drivers/usb/serial/usb-serial.c
>> +++ b/drivers/usb/serial/usb-serial.c
>
> [...]
>
>> @@ -437,11 +432,9 @@ static int serial_ioctl(struct tty_struct *tty,
>> struct file
>> *file,
>>
>>        /* pass on to the driver specific version of this function
>>           if it is available */
>> -       if (port->serial->type->ioctl) {
>> -               retval = port->serial->type->ioctl(tty, file, cmd, arg);
>> -       } else
>> -               retval = -ENOIOCTLCMD;
>> -       return retval;
>> +       if (port->serial->type->ioctl)
>> +               return port->serial->type->ioctl(tty, file, cmd, arg);
>> +        return -ENOIOCTLCMD;
>
>   Spaces instead of tab here...
>
>> @@ -1185,24 +1178,21 @@ int usb_serial_suspend(struct usb_interface *intf,
>> pm_message_t message)
>>        }
>>
>>        if (serial->type->suspend)
>> -               r = serial->type->suspend(serial, message);
>> +               return serial->type->suspend(serial, message);
>>
>> -       return r;
>> +       return 0;
>>  }
>>  EXPORT_SYMBOL(usb_serial_suspend);
>>
>>  int usb_serial_resume(struct usb_interface *intf)
>>  {
>>        struct usb_serial *serial = usb_get_intfdata(intf);
>> -       int rv;
>>
>>        serial->suspending = 0;
>> -       if (serial->type->resume)
>> -               rv = serial->type->resume(serial);
>> -       else
>> -               rv = usb_serial_generic_resume(serial);
>>
>> -       return rv;
>> +       return (serial->type->resume)
>
>   Parens totally not needed here.
>
>> +               ? serial->type->resume(serial)
>> +               : usb_serial_generic_resume(serial);
>>  }
>>  EXPORT_SYMBOL(usb_serial_resume);
>
> WBR, Sergei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
